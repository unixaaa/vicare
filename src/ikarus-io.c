/*
 * Ikarus Scheme -- A compiler for R6RS Scheme.
 * Copyright (C) 2006,2007,2008  Abdulaziz Ghuloum
 * Modified by Marco Maggi <marco.maggi-ipsu@poste.it>
 *
 * This program is free software:  you can redistribute it and/or modify
 * it under  the terms of  the GNU General  Public License version  3 as
 * published by the Free Software Foundation.
 *
 * This program is  distributed in the hope that it  will be useful, but
 * WITHOUT  ANY   WARRANTY;  without   even  the  implied   warranty  of
 * MERCHANTABILITY  or FITNESS FOR  A PARTICULAR  PURPOSE.  See  the GNU
 * General Public License for more details.
 *
 * You should  have received  a copy of  the GNU General  Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "internals.h"
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/uio.h>

/* file descriptors */
#define IK_FD_TO_NUM(fd)		IK_FIX(fd)
#define IK_NUM_TO_FD(fd)		IK_UNFIX(fd)


/** --------------------------------------------------------------------
 ** File descriptors handling for Scheme ports: opening and closing.
 ** ----------------------------------------------------------------- */

ikptr_t
ikrt_close_fd (ikptr_t fd /*, ikpcb_t* pcb */)
{
  int   rv;
  errno = 0;
  rv    = close(IK_NUM_TO_FD(fd));
  return (-1 != rv)? IK_FALSE_OBJECT : ik_errno_to_code();
}
ikptr_t
ikrt_open_input_fd (ikptr_t pathname_bv, ikptr_t ikopts /*, ikpcb_t* pcb */)
{
  const char *  pathname;
  IK_UNUSED int opts  = IK_UNFIX(ikopts);
  int           flags = O_RDONLY; /* no special flags supported at present */
  /* The "mode" value is used  only when creating the file, which should
     not happen here. */
  int           mode  = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
  int           fd;
  pathname = IK_BYTEVECTOR_DATA_CHARP(pathname_bv);
  errno    = 0;
  fd       = open(pathname, flags, mode);
  return (0 <= fd)? IK_FD_TO_NUM(fd) : ik_errno_to_code();
}
ikptr_t
ikrt_open_output_fd (ikptr_t pathname_bv, ikptr_t ikopts /*, ikpcb_t* pcb */)
{
  const char *  pathname;
  int           opts  = IK_UNFIX(ikopts);
  int           mode  = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
  int           flags = 0;
  int           fd;
  /*
   * File options:
   *
   *   (file-options)                                    => 0
   *   (file-options no-create)                          => #b0001 = 1
   *   (file-options no-fail)                            => #b0010 = 2
   *   (file-options no-create no-fail)                  => #b0011 = 3
   *   (file-options no-truncate)                        => #b0100 = 4
   *   (file-options no-create no-truncate)              => #b0101 = 5
   *   (file-options no-fail no-truncate)                => #b0110 = 6
   *   (file-options no-create no-fail no-truncate)      => #b0111 = 7
   *   (file-options executable)			 => #b1000 = 8
   *
   * According to R6RS:
   *
   *   When supplied  to an operation that  opens a file  for output, the
   *   file-options object returned by (FILE-OPTIONS) (without arguments)
   *   specifies that  the file is  created if it  does not exist  and an
   *   exception with condition type "&i/o-file-already-exists" is raised
   *   if it does exist.
   *
   * According to the GNU C Library documentation:
   *
   * O_CREAT
   *   If set the file will be created if it does not exists.
   *
   * O_CREAT | O_EXCL
   *   "open()" fails if the specified file already exists.
   *
   * O_TRUNC
   *   Truncate the file to zero length.
   */
  switch (opts & 7){
  case 0: flags = O_WRONLY | O_CREAT | O_EXCL ; /* (file-options) */
    break;
  case 1: flags = O_WRONLY | O_TRUNC          ; /* (file-options no-create) */
    break;
  case 2: flags = O_WRONLY | O_TRUNC | O_CREAT; /* (file-options no-fail) */
    break;
  case 3: flags = O_WRONLY | O_TRUNC          ; /* (file-options no-create no-fail) */
    break;
  case 4: flags = O_WRONLY | O_CREAT | O_EXCL ; /* (file-options no-truncate) */
    break;
  case 5: flags = O_WRONLY                    ; /* (file-options no-create no-truncate) */
    break;
  case 6: flags = O_WRONLY | O_CREAT          ; /* (file-options no-fail no-truncate) */
    break;
  case 7: flags = O_WRONLY                    ; /* (file-options no-create no-fail no-truncate) */
    break;
  }
  if (8 == (opts & 8)) {
    mode |= S_IXUSR | S_IXGRP | S_IXOTH;
  }
  pathname = IK_BYTEVECTOR_DATA_CHARP(pathname_bv);
  errno    = 0;
  fd       = open(pathname, flags, mode);
  return (0 <= fd)? IK_FD_TO_NUM(fd) : ik_errno_to_code();
}
ikptr_t
ikrt_open_input_output_fd (ikptr_t pathname_bv, ikptr_t ikopts /*, ikpcb_t* pcb */)
{
  const char *  pathname;
  int           opts  = IK_UNFIX(ikopts);
  int           mode  = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
  int           flags = 0;
  int           fd;
  /* With   the   exception  of   O_RDWR,   these   are   the  same   of
     "ikrt_open_output_fd()". */
  switch (opts) {
  case 0: flags = O_RDWR | O_CREAT | O_EXCL ; /* (file-options) */
    break;
  case 1: flags = O_RDWR | O_TRUNC          ; /* (file-options no-create) */
    break;
  case 2: flags = O_RDWR | O_TRUNC | O_CREAT; /* (file-options no-fail) */
    break;
  case 3: flags = O_RDWR | O_TRUNC          ; /* (file-options no-create no-fail) */
    break;
  case 4: flags = O_RDWR | O_CREAT | O_EXCL ; /* (file-options no-truncate) */
    break;
  case 5: flags = O_RDWR                    ; /* (file-options no-create no-truncate) */
    break;
  case 6: flags = O_RDWR | O_CREAT          ; /* (file-options no-fail no-truncate) */
    break;
  case 7: flags = O_RDWR                    ; /* (file-options no-create no-fail no-truncate) */
    break;
  }
  pathname = IK_BYTEVECTOR_DATA_CHARP(pathname_bv);
  errno = 0;
  fd    = open(pathname, flags, mode);
  return (0 <= fd)? IK_FD_TO_NUM(fd) : ik_errno_to_code();
}


/** --------------------------------------------------------------------
 ** File descriptors handling for Scheme ports: reading and writing.
 ** ----------------------------------------------------------------- */

ikptr_t
ikrt_read_fd (ikptr_t fd, ikptr_t buffer_bv, ikptr_t buffer_offset, ikptr_t requested_count /*, ikpcb_t* pcb */)
{
  ssize_t       rv;
  uint8_t *     buffer;
  buffer = ((uint8_t *)IK_BYTEVECTOR_DATA_VOIDP(buffer_bv)) + IK_UNFIX(buffer_offset);
  errno  = 0;
  rv     = read(IK_NUM_TO_FD(fd), buffer, IK_UNFIX(requested_count));
  return (0 <= rv)? IK_FIX(rv) : ik_errno_to_code();
}
ikptr_t
ikrt_write_fd (ikptr_t fd, ikptr_t buffer_bv, ikptr_t buffer_offset, ikptr_t requested_count /*, ikpcb_t* pcb */)
{
  ssize_t       rv;
  uint8_t *     buffer;
  buffer = ((uint8_t*)IK_BYTEVECTOR_DATA_VOIDP(buffer_bv)) + IK_UNFIX(buffer_offset);
  errno  = 0;
  rv     = write(IK_NUM_TO_FD(fd), buffer, IK_UNFIX(requested_count));
  return (0 <= rv)? IK_FIX(rv) : ik_errno_to_code();
}


/** --------------------------------------------------------------------
 ** File descriptors handling for Scheme ports: port position.
 ** ----------------------------------------------------------------- */

ikptr_t
ikrt_set_position (ikptr_t fd, ikptr_t pos /*, ikpcb_t* pcb */)
{
  off_t         offset;
  off_t         rv;
  offset = ik_integer_to_llong(pos);
  errno  = 0;
  rv     = lseek(IK_NUM_TO_FD(fd), offset, SEEK_SET);
  return (-1 != rv)? IK_FALSE_OBJECT : ik_errno_to_code();
}


/** --------------------------------------------------------------------
 ** File descriptors handling for Scheme ports: non-blocking mode.
 ** ----------------------------------------------------------------- */

ikptr_t
ikptr_fd_set_non_blocking_mode (ikptr_t s_fd, ikpcb_t * pcb)
{
#ifdef HAVE_FCNTL
  int		fd = IK_NUM_TO_FD(s_fd);
  int		rv = -1;
  errno = 0;
  rv = fcntl(fd, F_GETFL, 0);
  if (-1 == rv) return ik_errno_to_code();
  errno = 0;
  rv = fcntl(fd, F_SETFL, rv | O_NONBLOCK);
  return (-1 != rv)? IK_FIX(rv) : ik_errno_to_code();
#else
  feature_failure(__func__);
#endif
}
ikptr_t
ikptr_fd_unset_non_blocking_mode (ikptr_t s_fd, ikpcb_t * pcb)
{
#ifdef HAVE_FCNTL
  int		fd = IK_NUM_TO_FD(s_fd);
  int		rv = -1;
  errno = 0;
  rv = fcntl(fd, F_GETFL, 0);
  if (-1 == rv) return ik_errno_to_code();
  errno = 0;
  rv = fcntl(fd, F_SETFL, rv & (~O_NONBLOCK));
  return (-1 != rv)? IK_FIX(rv) : ik_errno_to_code();
#else
  feature_failure(__func__);
#endif
}
ikptr_t
ikptr_fd_ref_non_blocking_mode (ikptr_t s_fd, ikpcb_t * pcb)
{
#ifdef HAVE_FCNTL
  int		fd = IK_NUM_TO_FD(s_fd);
  int		rv = -1;
  errno = 0;
  rv = fcntl(fd, F_GETFL, 0);
  return (-1 != rv)? IK_BOOLEAN_FROM_INT(rv & O_NONBLOCK) : ik_errno_to_code();
#else
  feature_failure(__func__);
#endif
}

/* end of file */
