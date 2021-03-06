;;;!vicare
;;;
;;;Part of: Vicare Scheme
;;;Contents: demo program that connects to remote servers
;;;Date: Fri May 10, 2013
;;;
;;;Abstract
;;;
;;;	This is a demo script acting  similarly to the classic "telnet" unix program.
;;;	We can compile it with:
;;;
;;;        $ vicare -o connect -c connect.sps
;;;
;;;     To connect to "localhost" port 8080 we do:
;;;
;;;        $ connect localhost 8080
;;;
;;;     then we  start typing; there  is no  prompt; we tap  ^D to exit  the process.
;;;     See:
;;;
;;;        $ connect --help
;;;
;;;     for the list of options.
;;;
;;;Copyright (C) 2013, 2015 Marco Maggi <marco.maggi-ipsu@poste.it>
;;;
;;;This program is free software: you can  redistribute it and/or modify it under the
;;;terms  of  the GNU  General  Public  License as  published  by  the Free  Software
;;;Foundation,  either version  3  of the  License,  or (at  your  option) any  later
;;;version.
;;;
;;;This program is  distributed in the hope  that it will be useful,  but WITHOUT ANY
;;;WARRANTY; without  even the implied warranty  of MERCHANTABILITY or FITNESS  FOR A
;;;PARTICULAR PURPOSE.  See the GNU General Public License for more details.
;;;
;;;You should have received a copy of  the GNU General Public License along with this
;;;program.  If not, see <http://www.gnu.org/licenses/>.
;;;


#!vicare
(import (vicare)
  (prefix (vicare posix) px.)
  (prefix (vicare posix simple-event-loop) sel.)
  (vicare platform constants))


;;;; global variables

(define-constant VERSION-NUMBER
  "0.2d0")

;;; --------------------------------------------------------------------
;;; error codes for the primitive EXIT

(define-constant EXIT-SUCCESS 0)

;;Generic error code.
;;
(define-constant EXIT-FAILURE 1)

;;The exit status in case of "bad configuration option value".
;;
(define-constant EXIT-CODE/INVALID-GLOBAL-OPTION-VALUE 2)

;;The exit status in case of "exception not handled".
;;
(define-constant EXIT-CODE/UNHANDLED-EXCEPTION 99)


;;;; main function

(define (main argv)
  ;;This is the program entry point.  ARGV  is a list of strings representing command
  ;;line arguments.
  ;;
  ;;We catch  the exceptions to exit  with an error  code.  If we catch  an exception
  ;;here: we cannot log a message because we have already closed the log file.
  ;;
  ;;Log lines  specific to the raised  error should be  output near the cause  of the
  ;;error, where we can better explain what we were doing.
  ;;
  (try
      (begin
	(try
	    (with-global-options
		(command-line argv)
	      (with-compensations
		(open-session-logging (global-options.log-file))
		;;Catch the  exceptions here to log  the event: exit because  of error.
		;;Then raise again the exception to run the compensations and exit with
		;;error code.
		(with-logging-handler
		    (condition-message "exiting CONNECT client because of error: ~a")
		  (internal-body
		    (import CLIENT-CONNECTION-PROCEDURE)
		    (enter-client-connect (global-options.server-interface)
					  (global-options.server-port)
					  (global-options.client-connect-config))))
		(log-message "exiting CONNECT client")))
	  ;;Whatever the error: here we are only interested in the error message, unless it
	  ;;is an unknown error.
	  (catch E
	    ((&invalid-global-option-value &invalid-command-line-argument)
	     (error-message-and-exit EXIT-CODE/INVALID-GLOBAL-OPTION-VALUE (condition-message E)))
	    ((&session-logging)
	     (error-message-and-exit EXIT-FAILURE (condition-message E)))
	    ((&errno)
	     (error-message-and-exit EXIT-FAILURE (condition-message E)))
	    (else
	     (print-condition E)
	     (exit EXIT-CODE/UNHANDLED-EXCEPTION))))
	;;First make sure the allocated resources are released, then exit.
	(exit EXIT-SUCCESS))
    ;;If we are here: a second exception  was raised by the inner CATCH clauses while
    ;;handling a first exception.
    (catch E
      (else
       (print-condition E)
       (exit EXIT-FAILURE)))))


;;;; global options handling

(module GLOBAL-OPTIONS-CONTAINER
  (<global-options>
   &invalid-global-option-value)

  (define-record-type <global-options>
    (fields (mutable server-interface)
		;False or a  string representing the server interface  to connect to.
		;When false an error should be raised.
	    (mutable server-port)
		;False or  an exact integer  representing the server port  to connect
		;to.  When false an error should be raised.
	    (mutable log-file)
		;False or  a string representing  the pathname  of the log  file.  As
		;special case: if the string is "-" log messages should go to stderr.
	    (mutable client-connect-config)
		;ENUM-SET of type CLIENT-CONNECT-CONFIG.
	    (mutable verbosity)
		;An exact integer.  When zero: run  the program silently; this is the
		;default.   When a  positive integer:  run the  program with  verbose
		;messages at the appropriate verbosity level.
	    #| end of FIELDS |# )
    (protocol
     (lambda (make-record)
       (fluid-let-syntax ((__who__ (identifier-syntax 'make-<global-options>)))
	 (lambda (argv)
	   (import COMMAND-LINE-ARGS CLIENT-CONNECTION-PROCEDURE)
	   (receive-and-return (self)
	       (make-record #f ;interface
			    #f ;port
			    #f ;log-file
			    (client-connect-config)
			    0 ;verbosity
			    )
	     (parse-command-line-arguments self argv)

	     ;; validate client interface, more validation later
	     (let ((interface (<global-options>-server-interface self)))
	       (unless (and (string? interface)
			    (not (zero? (string-length interface))))
		 (raise-invalid-global-option-value __who__
		   "invalid server interface: \"~a\"" interface)))

	     ;; validate client port
	     (let ((port (<global-options>-server-port self)))
	       (cond ((not (px.network-port-number? port))
		      (raise-invalid-global-option-value __who__
			"invalid server port: \"~a\"" port))))


	     ;; validate log file
	     (let ((filename (<global-options>-log-file self)))
	       (cond ((not filename)
		      (void))
		     ((not (string? filename))
		      (raise-invalid-global-option-value __who__
			"internal error selecting log file pathname: ~a" filename))
		     ((string=? "-" filename)
		      ;;Log to the current error port.
		      (void))
		     ((zero? (string-length filename))
		      (raise-invalid-global-option-value __who__
			"selected empty log file pathname"))
		     (else
		      (let ((filename (%absolutise-pathname filename)))
			(when (and (file-exists? filename)
				   (not (and (px.file-is-regular-file? filename)
					     (px.file-writable?        filename))))
			  (raise-invalid-global-option-value __who__
			    "selected log file pathname not writable" filename))
			(<global-options>-log-file-set! self filename))))))))))
    #| end of DEFINE-RECORD-TYPE |# )

;;; --------------------------------------------------------------------
;;; error stuff

  (define-condition-type &invalid-global-option-value
      &error
    make-invalid-global-option-value-condition
    condition-invalid-global-option-value?)

  (define (raise-invalid-global-option-value who template . args)
    (raise
     (condition (make-who-condition who)
		(make-message-condition (apply format template args))
		(make-invalid-global-option-value-condition))))

;;; --------------------------------------------------------------------
;;; helpers

  (define (%absolutise-pathname pathname)
    (with-exception-handler
	(lambda (E)
	  (verbose-message 1 "error normalising log file pathname: ~a, ~a"
			   pathname (condition-message E))
	  (raise E))
      (lambda ()
	(cond ((file-exists? pathname)
	       (px.realpath/string pathname))
	      ((char=? #\/ (string-ref pathname 0))
	       ;;It is already an absolute pathname.
	       pathname)
	      (else
	       ;;It is a relative pathname.
	       (string-append (px.getcwd/string) "/" pathname))))))

  #| end of module |# )


;;;; command line arguments parsing

(module COMMAND-LINE-ARGS
  (parse-command-line-arguments
   &invalid-command-line-argument)
  (import (srfi :37 args-fold)
    GLOBAL-OPTIONS-CONTAINER)

  (define-syntax __module_who__
    (identifier-syntax 'parse-command-line-arguments))

  (define (parse-command-line-arguments seed argv)
    ;;NOTE We need to remember that upon entering this function call: the parameter
    ;;GLOBAL-OPTIONS is still set to #f.
    ;;
    (args-fold (cdr argv) program-options
	       unrecognised-option-proc
	       argument-processor
	       seed))

;;; --------------------------------------------------------------------

  (define-constant HELP-SCREEN
    "Usage: connect.sps [vicare options] -- INTERFACE PORT [options]
Options:
   --log-file /path/to/log-file
\tSelect the pathname for the log file.  Use \"-\" to log
\ton the error port.  When not given no log file is created.

   --recv-first
\tStart the client and expect the server to send the first
\tmessage.

   --send-first
\tStart the client and expect the client to send the first
\tmessage.

   -V
   --version
\tPrint version informations and exit.

   --version-only
\tPrint version number only and exit.

   -v
   --verbose
\tPrint verbose messages.

   -h
   --help
\tPrint this help screen and exit.\n")

  (define-constant VERSION-SCREEN
    "Vicare CONNECT ~a\n\
Copyright (C) 2013, 2015 Marco Maggi <marco.maggi-ipsu@poste.it>\n\
This is free software; see the source for copying conditions.  There is NO\n\
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.\n")

;;; --------------------------------------------------------------------

  (define (argument-processor operand seed)
    ;;We expect the interface name as first  argument and the port number as second
    ;;argument.
    ;;
    (cond ((not (slot-ref seed server-interface <global-options>))
	   ;;Select the interface to bind to.  We will validate this later.
	   (slot-set! seed server-interface <global-options> operand)
	   seed)
	  ((not (slot-ref seed server-port <global-options>))
	   (cond ((string->number operand)
		  => (lambda (port)
		       (slot-set! seed server-port <global-options> port)))
		 (else
		  (raise-invalid-command-line-argument __module_who__
		    "invalid port argument value: ~a" operand)))
	   seed)
	  (else
	   (raise-invalid-command-line-argument __module_who__
	     "invalid command line argument: ~a" operand))))

;;; --------------------------------------------------------------------

  (define (log-file-option-processor option name operand seed)
    (slot-set! seed log-file <global-options> operand)
    seed)

  (define (recv-first-option-processor option name operand seed)
    ;;Add RECV-FIRST to the enumeration set representing the options.
    ;;
    (import CLIENT-CONNECTION-PROCEDURE)
    (slot-set! seed client-connect-config <global-options>
	       (enum-set-union
		(slot-ref seed client-connect-config <global-options>)
		(client-connect-config recv-first)))
    seed)

  (define (send-first-option-processor option name operand seed)
    ;;Remove RECV-FIRST from the enumeration set representing the options.
    ;;
    (import CLIENT-CONNECTION-PROCEDURE)
    (slot-set! seed client-connect-config <global-options>
	       (enum-set-difference
		(slot-ref seed client-connect-config <global-options>)
		(client-connect-config recv-first)))
    seed)

;;; --------------------------------------------------------------------
;;; auxiliary options

  (define (verbosity-option-processor option name operand seed)
    ;;Increment the verbosity level.
    ;;
    (slot-set! seed verbosity <global-options>
	       (+ +1 (slot-ref seed verbosity <global-options>)))
    seed)

  (define (help-option-processor option name operand seed)
    (fprintf (current-error-port) HELP-SCREEN)
    (exit EXIT-SUCCESS))

  (define (version-option-processor option name operand seed)
    (fprintf (current-error-port) VERSION-SCREEN VERSION-NUMBER)
    (exit EXIT-SUCCESS))

  (define (version-only-option-processor option name operand seed)
    (fprintf (current-error-port) "~a\n" VERSION-NUMBER)
    (exit EXIT-SUCCESS))

;;; --------------------------------------------------------------------
;;; options definition

  (define program-options
    ;;List  of options  recognised  by this  program.  The  format  of each  option
    ;;specification is:
    ;;
    ;;   names required-arg? optional-arg? option-proc
    ;;
    (list
     (option '("log-file")	#t #f log-file-option-processor)
     (option '("recv-first")	#f #f recv-first-option-processor)
     (option '("send-first")	#f #f send-first-option-processor)

     (option '("version-only")	#f #f version-only-option-processor)
     (option '(#\V "version")	#f #f version-option-processor)
     (option '(#\v "verbose")	#f #f verbosity-option-processor)
     (option '(#\h "help")	#f #f help-option-processor)
     ))

;;; --------------------------------------------------------------------
;;; error stuff

  (define (invalid-option-value option value)
    (raise-invalid-command-line-argument __module_who__
      "invalid value for option \"~a\": ~a" option value))

  (define (unrecognised-option-proc option name arg seed)
    (raise-invalid-command-line-argument __module_who__
      "unknown command line option: ~a" name))

  (define-condition-type &invalid-command-line-argument
      &error
    make-invalid-command-line-argument-condition
    condition-invalid-command-line-argument?)

  (define (raise-invalid-command-line-argument who template . args)
    (raise
     (condition (make-who-condition who)
		(make-message-condition (apply format template args))
		(make-invalid-command-line-argument-condition))))


  #| end of module: COMMAND-LINE-ARGS |# )


;;;; public global options API

(module (with-global-options
	 global-options.server-interface
	 global-options.server-port
	 global-options.log-file
	 global-options.verbosity
	 global-options.client-connect-config
	 &invalid-global-option-value
	 &invalid-command-line-argument)
  (import GLOBAL-OPTIONS-CONTAINER)
  (module (&invalid-command-line-argument)
    (import COMMAND-LINE-ARGS))


  ;;An  instance of  record  type "<global-options>"  holding  global server  options
  ;;configured from the command line.
  ;;
  (define-constant global-options
    (make-parameter #f))

  (define-syntax with-global-options
    (syntax-rules (command-line)
      ((_ (command-line ?argv) ?body0 ?body ...)
       (parametrise ((global-options (<global-options> (?argv))))
	 ?body0 ?body ...))
      ))

;;; --------------------------------------------------------------------

  (define (global-options.server-interface)
    (slot-ref (global-options) server-interface <global-options>))

  (define (global-options.server-port)
    (slot-ref (global-options) server-port <global-options>))

  (define (global-options.log-file)
    ;;Return  false if  logging  must  be disabled.   Return  a string  if
    ;;logging must be  enabled; the string represents the  pathname of the
    ;;log file; as special case: if  the string is "-" log messages should
    ;;go to stderr.
    ;;
    (slot-ref (global-options) log-file <global-options>))

  (define (global-options.verbosity)
    (slot-ref (global-options) verbosity <global-options>))

  (define (global-options.client-connect-config)
    (slot-ref (global-options) client-connect-config <global-options>))

  #| end of module |# )


;;;; client events loop

(module CLIENT-CONNECTION-PROCEDURE
  (enter-client-connect client-connect-option client-connect-config)

  (define (enter-client-connect interface port options-set)
    ;;To be called  by the main client function.  Connect  to the server
    ;;and enter  the dialogue.  This  function returns when  the process
    ;;must be exited.
    ;;
    ;;Given  a  string INTERFACE  representing  a  network interface  to
    ;;connect to  and a network  PORT number: create the  client socket,
    ;;connect  to the  server, enter  the dialogue.   Return unspecified
    ;;values.
    ;;
    ;;INTERFACE must  be a string  representing the server  interface to
    ;;connect to; for example "localhost".
    ;;
    ;;PORT  must be  an exact  integer representing  the server  port to
    ;;connect to; for example 8081.
    ;;
    ;;OPTIONS-SET must be an  ENUM-SET of type CLIENT-CONNECT-OPTION; it
    ;;is used to configure the client connection.
    ;;
    (import INTERPROCESS-SIGNALS CONNECT-CLIENT)
    (with-compensations
      (compensate
	  (sel.initialise)
	(with
	 (sel.finalise)))
      (initialise-signal-handlers)
      (log-message "connecting to: ~a:~a" interface port)
      (letrec
	  ((server-port (with-logging-handler
			    (condition-message "while creating client socket: ~a")
			  (compensate
			      (px.tcp-connect interface port
					      (lambda (action hostname service sockaddr)
						(log-message "tcp-connect: ~a ~a ~a"
							     action hostname service)))
			    (with
			     (close-port server-port))))))

	(if (configured-to-recv-first? options-set)
	    (proto.start-recv-session server-port)
	  (proto.start-send-session server-port))
	;;We return  from this  form only  when it is  time to  exit the
	;;process.
	(sel.enter)))
    (void))

  (define-enumeration client-connect-option
    (recv-first
		;Start  the client  and expect  the server  to send  the
		;first message.
     )
    client-connect-config)

  (define (configured-to-recv-first? options-set)
    (enum-set-member? (client-connect-option recv-first) options-set))

  #| end of module: CLIENT-CONNECTION-PROCEDURE |# )


;;;; CONNECT client

(module CONNECT-CLIENT
  (proto.start-recv-session proto.start-send-session)
  (import (prefix (vicare net channels) chan.))

  (define-struct connection
    (terminal-chan server-chan server-port))

  (define (proto.start-recv-session server-port)
    ;;Start a session in which this client first receives a message from
    ;;the server.
    ;;
    (define conn (prepare-connection server-port))
    (log-message "expecting server to send first message")
    (chan.channel-recv-begin! (connection-server-chan conn))
    (schedule-server-incoming-data conn))

  (define (proto.start-send-session server-port)
    ;;Start a session in which this  client first sends a message to the
    ;;server.  We have to read a message form the terminal.
    ;;
    (define conn (prepare-connection server-port))
    (log-message "expecting client to send first message")
    (chan.channel-recv-begin! (connection-terminal-chan conn))
    (schedule-terminal-incoming-data conn))

;;; --------------------------------------------------------------------

  (define (prepare-connection server-port)
    ;;Prepare the terminal and server channel structures.
    ;;
    (with-logging-handler
	(condition-message "while starting session: ~a")
      (define terminal-chan
	(chan.open-textual-input/output-channel stdin stdout))
      (define server-chan
	(chan.open-textual-input/output-channel server-port server-port))
      (port-set-non-blocking-mode! server-port)
      (port-set-non-blocking-mode! stdin)
      (chan.channel-set-message-terminators! terminal-chan STRING-TERMINATORS)
      (chan.channel-set-message-terminators! server-chan   STRING-TERMINATORS)
      (make-connection terminal-chan server-chan server-port)))

  (define (close-connection conn)
    (with-compensations
      (push-compensation (sel.leave-asap))
      (log-message "closing connection")
      (chan.close-channel (connection-server-chan   conn))
      (chan.close-channel (connection-terminal-chan conn))
      (close-port (connection-server-port conn))))

;;; --------------------------------------------------------------------

  (define (schedule-terminal-incoming-data conn)
    ;;We do *not* want a timeout when reading from the terminal.
    ;;
    (sel.readable stdin (lambda ()
			  (with-exception-handler
			      (lambda (E)
				(log-message "error processing incoming terminal data: ~a" E)
				;;The  SEL will  catch and  discard this
				;;exception.
				(raise E))
			    (lambda ()
			      (process-terminal-incoming-data conn))))))

  (define (schedule-server-incoming-data conn)
    ;;We *do* want a timeout when reading from the socket.
    (sel.readable (connection-server-port conn)
		  (lambda ()
		    (with-exception-handler
			(lambda (E)
			  (log-message "error processing incoming server data: ~a" E)
			  ;;The   SEL  will   catch  and   discard  this
			  ;;exception.
			  (raise E))
		      (lambda ()
			(process-server-incoming-data conn))))
		  (time-from-now SOCKET-TIMEOUT-TIME)
		  (lambda ()
		    (log-message "connection expired")
		    (close-connection conn))))

  (define (schedule-server-outgoing-data conn . message-portions)
    ;;We *do* want a timeout when writing to a socket.
    (sel.writable (connection-server-port conn)
		  (lambda ()
		    (with-exception-handler
			(lambda (E)
			  (log-message "error processing outgoing server data: ~a" E)
			  ;;The   SEL  will   catch  and   discard  this
			  ;;exception.
			  (raise E))
		      (lambda ()
			(process-server-outgoing-data conn message-portions))))
		  (time-from-now SOCKET-TIMEOUT-TIME)
		  (lambda ()
		    (log-message "connection expired")
		    (close-connection conn))))

;;; --------------------------------------------------------------------

  (define (process-server-incoming-data conn)
    ;;To be called when there is incoming data available from the server
    ;;port.  Read the available data, then:
    ;;
    ;;* If  a message  terminator was  read: send  data to  the terminal
    ;;   channel, schedule  reading form  the terminal  and reenter  the
    ;;  event loop.
    ;;
    ;;* If  more incoming data  from the server is  expected: reschedule
    ;;  this function and reenter the event loop.
    ;;
    (with-logging-handler
	(condition-message "while processing server incoming data: ~a")
      (define server-chan
	(connection-server-chan conn))
      (define terminal-chan
	(connection-terminal-chan conn))
      #;(log-message "receiving message portion")
      (cond ((chan.channel-recv-message-portion! server-chan)
	     => (lambda (thing)
		  (cond ((eof-object? thing)
			 (log-message "connection closed by remote host")
			 (close-connection conn))
			((would-block-object? thing)
			 (schedule-server-incoming-data conn))
			(else
			 (let* ((data.str (chan.channel-recv-end! server-chan))
				(data.enc (ascii->string (uri-encode (string->ascii data.str)))))
			   (log-message "received: ~a" data.enc)
			   (chan.channel-send-full-message terminal-chan data.str)
			   (chan.channel-recv-begin! terminal-chan)
			   (schedule-terminal-incoming-data conn))))))
	    (else
	     (schedule-server-incoming-data conn)))))

  (define (process-server-outgoing-data conn message-portions)
    (with-logging-handler
	(condition-message "while processing server outgoing data: ~a")
      (define server-chan
	(connection-server-chan conn))
      (apply chan.channel-send-full-message server-chan message-portions)
      (chan.channel-recv-begin! server-chan)
      (schedule-server-incoming-data conn)))

  (define (process-terminal-incoming-data conn)
    ;;To  be called  when  there  is incoming  data  available from  the
    ;;terminal port.  Read the available data, then:
    ;;
    ;;*  If a  message  terminator was  read: send  data  to the  server
    ;;  channel, schedule  reading form the server port  and reenter the
    ;;  event loop.
    ;;
    ;;* If more incoming data  from the terminal is expected: reschedule
    ;;  this function and reenter the event loop.
    ;;
    (with-logging-handler
	(condition-message "while processing terminal incoming data: ~a")
      (define terminal-chan
	(connection-terminal-chan conn))
      (define server-chan
	(connection-server-chan conn))
      (cond ((chan.channel-recv-message-portion! terminal-chan)
	     => (lambda (thing)
		  (cond ((eof-object? thing)
			 (close-connection conn))
			((would-block-object? thing)
			 (schedule-terminal-incoming-data conn))
			(else
			 (let ((data.str (chan.channel-recv-end! terminal-chan)))
			   (log-message "sending command: ~a"
					(ascii->string (uri-encode (string->ascii data.str))))
			   (schedule-server-outgoing-data conn data.str))))))
	    (else
	     (schedule-terminal-incoming-data conn)))))

;;; --------------------------------------------------------------------

  (define (%received-quit? bv)
    ;;We know that the last bytes of BV must represent \n or \r\n.
    ;;
    (let ((bv.len (bytevector-length bv)))
      (cond ((and (fx<= 2 bv.len)
		  (fx=? (char->integer #\return)
			(bytevector-u8-ref bv (fx- bv.len 2)))
		  (fx=? (char->integer #\newline)
			(bytevector-u8-ref bv (fx- bv.len 1))))
	     (bytevector=? bv #ve(ascii "quit\r\n")))
	    ((and (fx<= 1 bv.len)
		  (fx=? (char->integer #\newline)
			(bytevector-u8-ref bv (fx- bv.len 1))))
	     (bytevector=? bv #ve(ascii "quit\n")))
	    (else #f))))

;;; --------------------------------------------------------------------

  (define-constant STRING-TERMINATORS
    '("\r\n" "\n"))

  (define-constant SOCKET-TIMEOUT-SECONDS
    10)

  (define-constant SOCKET-TIMEOUT-TIME
    (make-time SOCKET-TIMEOUT-SECONDS 0))

  #| end of module: CONNECT-CLIENT |# )


;;;; interprocess signal handlers

(module INTERPROCESS-SIGNALS
  (initialise-signal-handlers)

  (define (initialise-signal-handlers)
    (sel.receive-signal SIGTERM %sigterm-handler)
    (sel.receive-signal SIGQUIT %sigquit-handler)
    (sel.receive-signal SIGINT  %sigint-handler)
    (sel.receive-signal SIGTSTP %sigtstp-handler)
    (sel.receive-signal SIGCONT %sigcont-handler)
    (sel.receive-signal SIGUSR1 %sigusr1-handler)
    (sel.receive-signal SIGUSR2 %sigusr2-handler))

  (define (%sigterm-handler)
    (sel.receive-signal SIGTERM %sigterm-handler)
    (log-message "received SIGTERM")
    (sel.leave-asap))

  (define (%sigquit-handler)
    ;;SIGQUIT comes from Ctrl-\.  The documentation of the GNU C Library
    ;;has this to say about SIGQUIT:
    ;;
    ;;   The SIGQUIT  signal  is  similar to  SIGINT,  except that  it's
    ;;  controlled by  a different key and produces a  core dump when it
    ;;  terminates the  process, just like a program  error signal.  You
    ;;  can think of this as a program error condition "detected" by the
    ;;  user.
    ;;
    ;;  Certain kinds of cleanups  are best omitted in handling SIGQUIT.
    ;;  For example,  if the program creates temporary  files, it should
    ;;  handle the other termination  requests by deleting the temporary
    ;;  files.  But it is better for SIGQUIT not to delete them, so that
    ;;  the user can examine them in conjunction with the core dump.
    ;;
    (sel.receive-signal SIGQUIT %sigquit-handler)
    (log-message "received SIGQUIT")
    (sel.leave-asap))

  (define (%sigint-handler)
    ;;SIGINT comes from Ctrl-C.
    (sel.receive-signal SIGINT %sigint-handler)
    (log-message "received SIGINT")
    (sel.leave-asap))

  (define (%sigtstp-handler)
    ;;SIGTSTP  comes from  Ctrl-Z.   We should  put  some process  state
    ;;suspension  finalisation   in  this  handler.   Finally   we  send
    ;;ourselves a SIGSTOP to suspend the process.
    (with-logging-handler
	(condition-message "error in SIGTSTP handler: ~a")
      (sel.receive-signal SIGTSTP %sigtstp-handler)
      (log-message "received SIGTSTP")
      (px.kill (px.getpid) SIGSTOP)))

  (define (%sigcont-handler)
    ;;SIGCONT comes from the controlling process and allows us to resume
    ;;the program.  We should put some process state reinitialisation in
    ;;this handler.
    (with-logging-handler
	(condition-message "error in SIGCONT handler: ~a")
      (sel.receive-signal SIGCONT %sigcont-handler)
      (log-message "received SIGCONT")))

  (define (%sigusr1-handler)
    ;;SIGUSR1  is  explicitly  sent  by  someone  to  perform  a  custom
    ;;procedure.
    ;;
    (with-logging-handler
	(condition-message "error in SIGUSR1 handler: ~a")
      (sel.receive-signal SIGUSR1 %sigusr1-handler)
      (log-message "received SIGUSR1")))

  (define (%sigusr2-handler)
    ;;SIGUSR2  is  explicitly  sent  by  someone  to  perform  a  custom
    ;;procedure.
    ;;
    (with-logging-handler
	(condition-message "error in SIGUSR2 handler: ~a")
      (sel.receive-signal SIGUSR2 %sigusr2-handler)
      (log-message "received SIGUSR2")))

  #| end of module: INTERPROCESS-SIGNALS |# )


;;;; logging facilities

(module (open-session-logging
	 with-logging-handler
	 log-message
	 &session-logging)
  ;;NOTE We decide  to raise an exception if logging  messages fails.  Another choice
  ;;would be to block exceptions in LOG-MESSAGE and let the process go on.
  ;;
  (import (prefix (vicare posix log-files) log.))

  (define (open-session-logging log-file)
    (log.logging-enabled? log-file)
    (log.log-pathname     log-file)
    (with-exception-handler
	(lambda (E)
	  (%re-raise-exception "while opening log file" E))
      (lambda ()
	(log.setup-compensated-log-file-creation)))
    (with-exception-handler
	(lambda (E)
	  (%re-raise-exception "while logging start messages" E))
      (lambda ()
	(let ((pid (px.getpid)))
	  (log.log-prefix (format "vicare connect[~a]: " pid))
	  (log.log "*** starting CONNECT client, pid=~a" pid)))))

  (define (log-message template . args)
    (with-exception-handler
	(lambda (E)
	  (%re-raise-exception "while logging message" E))
      (lambda ()
	(apply log.log template args))))

  (define-syntax-rule (with-logging-handler ?template . ?body)
    (log.with-logging-handler ?template . ?body))

;;; --------------------------------------------------------------------

  (define-condition-type &session-logging
      &error
    make-session-logging-condition
    condition-session-logging?)

  (define (%re-raise-exception description E)
    (raise
     (condition
      (make-session-logging-condition)
      (make-message-condition (format "~a: ~a" description
				      (if (message-condition? E)
					  (condition-message E)
					"unknown error"))))))

  #| end of module |# )


;;;; printing helpers

(module (verbose-message error-message-and-exit)

  (define (verbose-message requested-level template . args)
    (when (<= (global-options.verbosity) requested-level)
      (%format-and-print (current-error-port) template args)))

  (define (error-message-and-exit exit-code template . args)
    (%format-and-print (current-error-port) template args)
    (exit exit-code))

;;; --------------------------------------------------------------------

  (define (%format-and-print port template args)
    (fprintf port "connect: ")
    (apply fprintf port template args)
    (newline port)
    (flush-output-port port))

  #| end of module |# )


;;;; done

(main (command-line))

;;; end of file
;; Local Variables:
;; coding: utf-8-unix
;; eval: (put 'with-global-options		'scheme-indent-function 1)
;; eval: (put 'with-logging-handler		'scheme-indent-function 1)
;; eval: (put 'error-message-and-exit		'scheme-indent-function 1)
;; eval: (put 'raise-invalid-global-option-value 'scheme-indent-function 1)
;; End:
