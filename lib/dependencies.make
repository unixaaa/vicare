## dependencies.make --
#
# Automatically built.

EXTRA_DIST +=  \
	lib/vicare/platform/configuration.sls.in \
	lib/nausicaa/uri/pathnames.sls.in \
	lib/vicare/platform/constants.sls.in \
	lib/vicare/platform/errno.sls.in \
	lib/vicare/platform/words.sls.in

lib/vicare/platform/configuration.fasl: \
		lib/vicare/platform/configuration.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_platform_configuration_fasldir = $(bundledlibsdir)/vicare/platform
nodist_lib_vicare_platform_configuration_fasl_DATA = lib/vicare/platform/configuration.fasl
CLEANFILES += lib/vicare/platform/configuration.fasl

lib/vicare/platform/words.fasl: \
		lib/vicare/platform/words.sls \
		lib/vicare/platform/configuration.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_platform_words_fasldir = $(bundledlibsdir)/vicare/platform
nodist_lib_vicare_platform_words_fasl_DATA = lib/vicare/platform/words.fasl
CLEANFILES += lib/vicare/platform/words.fasl

lib/vicare/platform/errno.fasl: \
		lib/vicare/platform/errno.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_platform_errno_fasldir = $(bundledlibsdir)/vicare/platform
nodist_lib_vicare_platform_errno_fasl_DATA = lib/vicare/platform/errno.fasl
CLEANFILES += lib/vicare/platform/errno.fasl

lib/vicare/platform/constants.fasl: \
		lib/vicare/platform/constants.sls \
		lib/vicare/platform/errno.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_platform_constants_fasldir = $(bundledlibsdir)/vicare/platform
nodist_lib_vicare_platform_constants_fasl_DATA = lib/vicare/platform/constants.fasl
CLEANFILES += lib/vicare/platform/constants.fasl

lib/vicare/platform/features.fasl: \
		lib/vicare/platform/features.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_platform_features_fasldir = $(bundledlibsdir)/vicare/platform
nodist_lib_vicare_platform_features_fasl_DATA = lib/vicare/platform/features.fasl
CLEANFILES += lib/vicare/platform/features.fasl

lib/vicare/platform/utilities.fasl: \
		lib/vicare/platform/utilities.sls \
		lib/vicare/platform/constants.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_platform_utilities_fasldir = $(bundledlibsdir)/vicare/platform
nodist_lib_vicare_platform_utilities_fasl_DATA = lib/vicare/platform/utilities.fasl
EXTRA_DIST += lib/vicare/platform/utilities.sls
CLEANFILES += lib/vicare/platform/utilities.fasl

lib/vicare/unsafe/capi.fasl: \
		lib/vicare/unsafe/capi.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_unsafe_capi_fasldir = $(bundledlibsdir)/vicare/unsafe
nodist_lib_vicare_unsafe_capi_fasl_DATA = lib/vicare/unsafe/capi.fasl
EXTRA_DIST += lib/vicare/unsafe/capi.sls
CLEANFILES += lib/vicare/unsafe/capi.fasl

lib/vicare/unsafe/operations.fasl: \
		lib/vicare/unsafe/operations.sls \
		lib/vicare/platform/configuration.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_unsafe_operations_fasldir = $(bundledlibsdir)/vicare/unsafe
nodist_lib_vicare_unsafe_operations_fasl_DATA = lib/vicare/unsafe/operations.fasl
EXTRA_DIST += lib/vicare/unsafe/operations.sls
CLEANFILES += lib/vicare/unsafe/operations.fasl

lib/vicare/unsafe/unicode.fasl: \
		lib/vicare/unsafe/unicode.sls \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_unsafe_unicode_fasldir = $(bundledlibsdir)/vicare/unsafe
nodist_lib_vicare_unsafe_unicode_fasl_DATA = lib/vicare/unsafe/unicode.fasl
EXTRA_DIST += lib/vicare/unsafe/unicode.sls
CLEANFILES += lib/vicare/unsafe/unicode.fasl

lib/vicare/language-extensions/cond-expand.fasl: \
		lib/vicare/language-extensions/cond-expand.sls \
		lib/vicare/language-extensions/cond-expand/registry.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_cond_expand_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_cond_expand_fasl_DATA = lib/vicare/language-extensions/cond-expand.fasl
EXTRA_DIST += lib/vicare/language-extensions/cond-expand.sls
CLEANFILES += lib/vicare/language-extensions/cond-expand.fasl

lib/vicare/language-extensions/cond-expand/registry.fasl: \
		lib/vicare/language-extensions/cond-expand/registry.sls \
		lib/vicare/language-extensions/cond-expand/platform-features.fasl \
		lib/vicare/language-extensions/cond-expand/configuration-features.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_cond_expand_registry_fasldir = $(bundledlibsdir)/vicare/language-extensions/cond-expand
nodist_lib_vicare_language_extensions_cond_expand_registry_fasl_DATA = lib/vicare/language-extensions/cond-expand/registry.fasl
EXTRA_DIST += lib/vicare/language-extensions/cond-expand/registry.sls
CLEANFILES += lib/vicare/language-extensions/cond-expand/registry.fasl

lib/vicare/language-extensions/cond-expand/platform-features.fasl: \
		lib/vicare/language-extensions/cond-expand/platform-features.sls \
		lib/vicare/language-extensions/cond-expand/OS-id-features.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_cond_expand_platform_features_fasldir = $(bundledlibsdir)/vicare/language-extensions/cond-expand
nodist_lib_vicare_language_extensions_cond_expand_platform_features_fasl_DATA = lib/vicare/language-extensions/cond-expand/platform-features.fasl
EXTRA_DIST += lib/vicare/language-extensions/cond-expand/platform-features.sls
CLEANFILES += lib/vicare/language-extensions/cond-expand/platform-features.fasl

lib/vicare/language-extensions/cond-expand/OS-id-features.fasl: \
		lib/vicare/language-extensions/cond-expand/OS-id-features.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_cond_expand_OS_id_features_fasldir = $(bundledlibsdir)/vicare/language-extensions/cond-expand
nodist_lib_vicare_language_extensions_cond_expand_OS_id_features_fasl_DATA = lib/vicare/language-extensions/cond-expand/OS-id-features.fasl
EXTRA_DIST += lib/vicare/language-extensions/cond-expand/OS-id-features.sls
CLEANFILES += lib/vicare/language-extensions/cond-expand/OS-id-features.fasl

lib/vicare/language-extensions/cond-expand/configuration-features.fasl: \
		lib/vicare/language-extensions/cond-expand/configuration-features.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_cond_expand_configuration_features_fasldir = $(bundledlibsdir)/vicare/language-extensions/cond-expand
nodist_lib_vicare_language_extensions_cond_expand_configuration_features_fasl_DATA = lib/vicare/language-extensions/cond-expand/configuration-features.fasl
EXTRA_DIST += lib/vicare/language-extensions/cond-expand/configuration-features.sls
CLEANFILES += lib/vicare/language-extensions/cond-expand/configuration-features.fasl

lib/vicare/language-extensions/cond-expand/feature-cond.fasl: \
		lib/vicare/language-extensions/cond-expand/feature-cond.sls \
		lib/vicare/language-extensions/cond-expand/registry.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_cond_expand_feature_cond_fasldir = $(bundledlibsdir)/vicare/language-extensions/cond-expand
nodist_lib_vicare_language_extensions_cond_expand_feature_cond_fasl_DATA = lib/vicare/language-extensions/cond-expand/feature-cond.fasl
EXTRA_DIST += lib/vicare/language-extensions/cond-expand/feature-cond.sls
CLEANFILES += lib/vicare/language-extensions/cond-expand/feature-cond.fasl

lib/vicare/language-extensions/cond-expand/helpers.fasl: \
		lib/vicare/language-extensions/cond-expand/helpers.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_cond_expand_helpers_fasldir = $(bundledlibsdir)/vicare/language-extensions/cond-expand
nodist_lib_vicare_language_extensions_cond_expand_helpers_fasl_DATA = lib/vicare/language-extensions/cond-expand/helpers.fasl
EXTRA_DIST += lib/vicare/language-extensions/cond-expand/helpers.sls
CLEANFILES += lib/vicare/language-extensions/cond-expand/helpers.fasl

lib/vicare/arguments/validation.fasl: \
		lib/vicare/arguments/validation.sls \
		lib/vicare/platform/configuration.fasl \
		lib/vicare/platform/constants.fasl \
		lib/vicare/platform/words.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_arguments_validation_fasldir = $(bundledlibsdir)/vicare/arguments
nodist_lib_vicare_arguments_validation_fasl_DATA = lib/vicare/arguments/validation.fasl
EXTRA_DIST += lib/vicare/arguments/validation.sls
CLEANFILES += lib/vicare/arguments/validation.fasl

lib/vicare/arguments/general-c-buffers.fasl: \
		lib/vicare/arguments/general-c-buffers.sls \
		lib/vicare/language-extensions/syntaxes.fasl \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_arguments_general_c_buffers_fasldir = $(bundledlibsdir)/vicare/arguments
nodist_lib_vicare_arguments_general_c_buffers_fasl_DATA = lib/vicare/arguments/general-c-buffers.fasl
EXTRA_DIST += lib/vicare/arguments/general-c-buffers.sls
CLEANFILES += lib/vicare/arguments/general-c-buffers.fasl

lib/vicare/language-extensions/syntaxes.fasl: \
		lib/vicare/language-extensions/syntaxes.sls \
		lib/vicare/platform/configuration.fasl \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/language-extensions/define-record-extended.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_syntaxes_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_syntaxes_fasl_DATA = lib/vicare/language-extensions/syntaxes.fasl
EXTRA_DIST += lib/vicare/language-extensions/syntaxes.sls
CLEANFILES += lib/vicare/language-extensions/syntaxes.fasl

lib/vicare/language-extensions/define-record-extended.fasl: \
		lib/vicare/language-extensions/define-record-extended.sls \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_define_record_extended_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_define_record_extended_fasl_DATA = lib/vicare/language-extensions/define-record-extended.fasl
EXTRA_DIST += lib/vicare/language-extensions/define-record-extended.sls
CLEANFILES += lib/vicare/language-extensions/define-record-extended.fasl

lib/vicare/language-extensions/amb.fasl: \
		lib/vicare/language-extensions/amb.sls \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_amb_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_amb_fasl_DATA = lib/vicare/language-extensions/amb.fasl
EXTRA_DIST += lib/vicare/language-extensions/amb.sls
CLEANFILES += lib/vicare/language-extensions/amb.fasl

lib/vicare/language-extensions/simple-match.fasl: \
		lib/vicare/language-extensions/simple-match.sls \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_simple_match_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_simple_match_fasl_DATA = lib/vicare/language-extensions/simple-match.fasl
EXTRA_DIST += lib/vicare/language-extensions/simple-match.sls
CLEANFILES += lib/vicare/language-extensions/simple-match.fasl

lib/vicare/language-extensions/coroutines.fasl: \
		lib/vicare/language-extensions/coroutines.sls \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_coroutines_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_coroutines_fasl_DATA = lib/vicare/language-extensions/coroutines.fasl
EXTRA_DIST += lib/vicare/language-extensions/coroutines.sls
CLEANFILES += lib/vicare/language-extensions/coroutines.fasl

lib/vicare/language-extensions/increments.fasl: \
		lib/vicare/language-extensions/increments.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_increments_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_increments_fasl_DATA = lib/vicare/language-extensions/increments.fasl
EXTRA_DIST += lib/vicare/language-extensions/increments.sls
CLEANFILES += lib/vicare/language-extensions/increments.fasl

lib/vicare/language-extensions/infix.fasl: \
		lib/vicare/language-extensions/infix.sls \
		lib/vicare/language-extensions/infix/parser-utils.fasl \
		lib/vicare/language-extensions/infix/auxiliary-syntaxes.fasl \
		lib/vicare/language-extensions/increments.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_infix_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_infix_fasl_DATA = lib/vicare/language-extensions/infix.fasl
EXTRA_DIST += lib/vicare/language-extensions/infix.sls
CLEANFILES += lib/vicare/language-extensions/infix.fasl

lib/vicare/language-extensions/infix/parser-utils.fasl: \
		lib/vicare/language-extensions/infix/parser-utils.sls \
		lib/vicare/language-extensions/increments.fasl \
		lib/vicare/language-extensions/infix/auxiliary-syntaxes.fasl \
		lib/vicare/language-extensions/infix/tokens.fasl \
		lib/vicare/language-extensions/infix/parser-table.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_infix_parser_utils_fasldir = $(bundledlibsdir)/vicare/language-extensions/infix
nodist_lib_vicare_language_extensions_infix_parser_utils_fasl_DATA = lib/vicare/language-extensions/infix/parser-utils.fasl
EXTRA_DIST += lib/vicare/language-extensions/infix/parser-utils.sls
CLEANFILES += lib/vicare/language-extensions/infix/parser-utils.fasl

lib/vicare/language-extensions/infix/auxiliary-syntaxes.fasl: \
		lib/vicare/language-extensions/infix/auxiliary-syntaxes.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_infix_auxiliary_syntaxes_fasldir = $(bundledlibsdir)/vicare/language-extensions/infix
nodist_lib_vicare_language_extensions_infix_auxiliary_syntaxes_fasl_DATA = lib/vicare/language-extensions/infix/auxiliary-syntaxes.fasl
EXTRA_DIST += lib/vicare/language-extensions/infix/auxiliary-syntaxes.sls
CLEANFILES += lib/vicare/language-extensions/infix/auxiliary-syntaxes.fasl

lib/vicare/language-extensions/infix/tokens.fasl: \
		lib/vicare/language-extensions/infix/tokens.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_infix_tokens_fasldir = $(bundledlibsdir)/vicare/language-extensions/infix
nodist_lib_vicare_language_extensions_infix_tokens_fasl_DATA = lib/vicare/language-extensions/infix/tokens.fasl
EXTRA_DIST += lib/vicare/language-extensions/infix/tokens.sls
CLEANFILES += lib/vicare/language-extensions/infix/tokens.fasl

lib/vicare/language-extensions/infix/parser-table.fasl: \
		lib/vicare/language-extensions/infix/parser-table.sls \
		lib/vicare/language-extensions/infix/lr-driver.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_infix_parser_table_fasldir = $(bundledlibsdir)/vicare/language-extensions/infix
nodist_lib_vicare_language_extensions_infix_parser_table_fasl_DATA = lib/vicare/language-extensions/infix/parser-table.fasl
EXTRA_DIST += lib/vicare/language-extensions/infix/parser-table.sls
CLEANFILES += lib/vicare/language-extensions/infix/parser-table.fasl

lib/vicare/language-extensions/infix/lr-driver.fasl: \
		lib/vicare/language-extensions/infix/lr-driver.sls \
		lib/vicare/language-extensions/infix/tokens.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_infix_lr_driver_fasldir = $(bundledlibsdir)/vicare/language-extensions/infix
nodist_lib_vicare_language_extensions_infix_lr_driver_fasl_DATA = lib/vicare/language-extensions/infix/lr-driver.fasl
EXTRA_DIST += lib/vicare/language-extensions/infix/lr-driver.sls
CLEANFILES += lib/vicare/language-extensions/infix/lr-driver.fasl

lib/vicare/language-extensions/keywords.fasl: \
		lib/vicare/language-extensions/keywords.sls \
		lib/vicare/language-extensions/syntaxes.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_keywords_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_keywords_fasl_DATA = lib/vicare/language-extensions/keywords.fasl
EXTRA_DIST += lib/vicare/language-extensions/keywords.sls
CLEANFILES += lib/vicare/language-extensions/keywords.fasl

lib/vicare/language-extensions/sentinels.fasl: \
		lib/vicare/language-extensions/sentinels.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_sentinels_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_sentinels_fasl_DATA = lib/vicare/language-extensions/sentinels.fasl
EXTRA_DIST += lib/vicare/language-extensions/sentinels.sls
CLEANFILES += lib/vicare/language-extensions/sentinels.fasl

lib/vicare/language-extensions/namespaces.fasl: \
		lib/vicare/language-extensions/namespaces.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_namespaces_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_namespaces_fasl_DATA = lib/vicare/language-extensions/namespaces.fasl
EXTRA_DIST += lib/vicare/language-extensions/namespaces.sls
CLEANFILES += lib/vicare/language-extensions/namespaces.fasl

lib/vicare/language-extensions/custom-ports.fasl: \
		lib/vicare/language-extensions/custom-ports.sls \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_custom_ports_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_custom_ports_fasl_DATA = lib/vicare/language-extensions/custom-ports.fasl
EXTRA_DIST += lib/vicare/language-extensions/custom-ports.sls
CLEANFILES += lib/vicare/language-extensions/custom-ports.fasl

lib/vicare/language-extensions/variables.fasl: \
		lib/vicare/language-extensions/variables.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_variables_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_variables_fasl_DATA = lib/vicare/language-extensions/variables.fasl
EXTRA_DIST += lib/vicare/language-extensions/variables.sls
CLEANFILES += lib/vicare/language-extensions/variables.fasl

lib/vicare/language-extensions/streams.fasl: \
		lib/vicare/language-extensions/streams.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_streams_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_streams_fasl_DATA = lib/vicare/language-extensions/streams.fasl
EXTRA_DIST += lib/vicare/language-extensions/streams.sls
CLEANFILES += lib/vicare/language-extensions/streams.fasl

lib/vicare/language-extensions/loops.fasl: \
		lib/vicare/language-extensions/loops.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_loops_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_loops_fasl_DATA = lib/vicare/language-extensions/loops.fasl
EXTRA_DIST += lib/vicare/language-extensions/loops.sls
CLEANFILES += lib/vicare/language-extensions/loops.fasl

lib/vicare/language-extensions/ascii-chars.fasl: \
		lib/vicare/language-extensions/ascii-chars.sls \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/language-extensions/ascii-chars/syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_ascii_chars_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_ascii_chars_fasl_DATA = lib/vicare/language-extensions/ascii-chars.fasl
EXTRA_DIST += lib/vicare/language-extensions/ascii-chars.sls
CLEANFILES += lib/vicare/language-extensions/ascii-chars.fasl

lib/vicare/language-extensions/ascii-chars/syntaxes.fasl: \
		lib/vicare/language-extensions/ascii-chars/syntaxes.sls \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_ascii_chars_syntaxes_fasldir = $(bundledlibsdir)/vicare/language-extensions/ascii-chars
nodist_lib_vicare_language_extensions_ascii_chars_syntaxes_fasl_DATA = lib/vicare/language-extensions/ascii-chars/syntaxes.fasl
EXTRA_DIST += lib/vicare/language-extensions/ascii-chars/syntaxes.sls
CLEANFILES += lib/vicare/language-extensions/ascii-chars/syntaxes.fasl

lib/vicare/language-extensions/comparisons.fasl: \
		lib/vicare/language-extensions/comparisons.sls \
		lib/vicare/crypto/randomisations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_comparisons_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_comparisons_fasl_DATA = lib/vicare/language-extensions/comparisons.fasl
EXTRA_DIST += lib/vicare/language-extensions/comparisons.sls
CLEANFILES += lib/vicare/language-extensions/comparisons.fasl

lib/vicare/crypto/randomisations.fasl: \
		lib/vicare/crypto/randomisations.sls \
		lib/vicare/crypto/randomisations/low.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_crypto_randomisations_fasldir = $(bundledlibsdir)/vicare/crypto
nodist_lib_vicare_crypto_randomisations_fasl_DATA = lib/vicare/crypto/randomisations.fasl
EXTRA_DIST += lib/vicare/crypto/randomisations.sls
CLEANFILES += lib/vicare/crypto/randomisations.fasl

lib/vicare/crypto/randomisations/low.fasl: \
		lib/vicare/crypto/randomisations/low.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_crypto_randomisations_low_fasldir = $(bundledlibsdir)/vicare/crypto/randomisations
nodist_lib_vicare_crypto_randomisations_low_fasl_DATA = lib/vicare/crypto/randomisations/low.fasl
EXTRA_DIST += lib/vicare/crypto/randomisations/low.sls
CLEANFILES += lib/vicare/crypto/randomisations/low.fasl

lib/vicare/language-extensions/hooks.fasl: \
		lib/vicare/language-extensions/hooks.sls \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_hooks_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_hooks_fasl_DATA = lib/vicare/language-extensions/hooks.fasl
EXTRA_DIST += lib/vicare/language-extensions/hooks.sls
CLEANFILES += lib/vicare/language-extensions/hooks.fasl

lib/vicare/language-extensions/callables.fasl: \
		lib/vicare/language-extensions/callables.sls \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_callables_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_callables_fasl_DATA = lib/vicare/language-extensions/callables.fasl
EXTRA_DIST += lib/vicare/language-extensions/callables.sls
CLEANFILES += lib/vicare/language-extensions/callables.fasl

lib/vicare/language-extensions/c-enumerations.fasl: \
		lib/vicare/language-extensions/c-enumerations.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_c_enumerations_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_c_enumerations_fasl_DATA = lib/vicare/language-extensions/c-enumerations.fasl
EXTRA_DIST += lib/vicare/language-extensions/c-enumerations.sls
CLEANFILES += lib/vicare/language-extensions/c-enumerations.fasl

lib/vicare/language-extensions/identifier-substitutions.fasl: \
		lib/vicare/language-extensions/identifier-substitutions.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_identifier_substitutions_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_identifier_substitutions_fasl_DATA = lib/vicare/language-extensions/identifier-substitutions.fasl
EXTRA_DIST += lib/vicare/language-extensions/identifier-substitutions.sls
CLEANFILES += lib/vicare/language-extensions/identifier-substitutions.fasl

lib/vicare/language-extensions/makers.fasl: \
		lib/vicare/language-extensions/makers.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_makers_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_makers_fasl_DATA = lib/vicare/language-extensions/makers.fasl
EXTRA_DIST += lib/vicare/language-extensions/makers.sls
CLEANFILES += lib/vicare/language-extensions/makers.fasl

lib/vicare/language-extensions/try.fasl: \
		lib/vicare/language-extensions/try.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_language_extensions_try_fasldir = $(bundledlibsdir)/vicare/language-extensions
nodist_lib_vicare_language_extensions_try_fasl_DATA = lib/vicare/language-extensions/try.fasl
EXTRA_DIST += lib/vicare/language-extensions/try.sls
CLEANFILES += lib/vicare/language-extensions/try.fasl

lib/vicare/checks.fasl: \
		lib/vicare/checks.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_checks_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_checks_fasl_DATA = lib/vicare/checks.fasl
EXTRA_DIST += lib/vicare/checks.sls
CLEANFILES += lib/vicare/checks.fasl

lib/vicare/crypto/randomisations/blum-blum-shub.fasl: \
		lib/vicare/crypto/randomisations/blum-blum-shub.sls \
		lib/vicare/crypto/randomisations.fasl \
		lib/vicare/crypto/randomisations/low.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_crypto_randomisations_blum_blum_shub_fasldir = $(bundledlibsdir)/vicare/crypto/randomisations
nodist_lib_vicare_crypto_randomisations_blum_blum_shub_fasl_DATA = lib/vicare/crypto/randomisations/blum-blum-shub.fasl
EXTRA_DIST += lib/vicare/crypto/randomisations/blum-blum-shub.sls
CLEANFILES += lib/vicare/crypto/randomisations/blum-blum-shub.fasl

lib/vicare/crypto/randomisations/borosh.fasl: \
		lib/vicare/crypto/randomisations/borosh.sls \
		lib/vicare/crypto/randomisations.fasl \
		lib/vicare/crypto/randomisations/low.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_crypto_randomisations_borosh_fasldir = $(bundledlibsdir)/vicare/crypto/randomisations
nodist_lib_vicare_crypto_randomisations_borosh_fasl_DATA = lib/vicare/crypto/randomisations/borosh.fasl
EXTRA_DIST += lib/vicare/crypto/randomisations/borosh.sls
CLEANFILES += lib/vicare/crypto/randomisations/borosh.fasl

lib/vicare/crypto/randomisations/cmrg.fasl: \
		lib/vicare/crypto/randomisations/cmrg.sls \
		lib/vicare/crypto/randomisations.fasl \
		lib/vicare/crypto/randomisations/low.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_crypto_randomisations_cmrg_fasldir = $(bundledlibsdir)/vicare/crypto/randomisations
nodist_lib_vicare_crypto_randomisations_cmrg_fasl_DATA = lib/vicare/crypto/randomisations/cmrg.fasl
EXTRA_DIST += lib/vicare/crypto/randomisations/cmrg.sls
CLEANFILES += lib/vicare/crypto/randomisations/cmrg.fasl

lib/vicare/crypto/randomisations/distributions.fasl: \
		lib/vicare/crypto/randomisations/distributions.sls \
		lib/vicare/crypto/randomisations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_crypto_randomisations_distributions_fasldir = $(bundledlibsdir)/vicare/crypto/randomisations
nodist_lib_vicare_crypto_randomisations_distributions_fasl_DATA = lib/vicare/crypto/randomisations/distributions.fasl
EXTRA_DIST += lib/vicare/crypto/randomisations/distributions.sls
CLEANFILES += lib/vicare/crypto/randomisations/distributions.fasl

lib/vicare/crypto/randomisations/lists.fasl: \
		lib/vicare/crypto/randomisations/lists.sls \
		lib/vicare/crypto/randomisations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_crypto_randomisations_lists_fasldir = $(bundledlibsdir)/vicare/crypto/randomisations
nodist_lib_vicare_crypto_randomisations_lists_fasl_DATA = lib/vicare/crypto/randomisations/lists.fasl
EXTRA_DIST += lib/vicare/crypto/randomisations/lists.sls
CLEANFILES += lib/vicare/crypto/randomisations/lists.fasl

lib/vicare/crypto/randomisations/marsaglia.fasl: \
		lib/vicare/crypto/randomisations/marsaglia.sls \
		lib/vicare/crypto/randomisations.fasl \
		lib/vicare/crypto/randomisations/low.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_crypto_randomisations_marsaglia_fasldir = $(bundledlibsdir)/vicare/crypto/randomisations
nodist_lib_vicare_crypto_randomisations_marsaglia_fasl_DATA = lib/vicare/crypto/randomisations/marsaglia.fasl
EXTRA_DIST += lib/vicare/crypto/randomisations/marsaglia.sls
CLEANFILES += lib/vicare/crypto/randomisations/marsaglia.fasl

lib/vicare/crypto/randomisations/mersenne.fasl: \
		lib/vicare/crypto/randomisations/mersenne.sls \
		lib/vicare/crypto/randomisations.fasl \
		lib/vicare/crypto/randomisations/low.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_crypto_randomisations_mersenne_fasldir = $(bundledlibsdir)/vicare/crypto/randomisations
nodist_lib_vicare_crypto_randomisations_mersenne_fasl_DATA = lib/vicare/crypto/randomisations/mersenne.fasl
EXTRA_DIST += lib/vicare/crypto/randomisations/mersenne.sls
CLEANFILES += lib/vicare/crypto/randomisations/mersenne.fasl

lib/vicare/crypto/randomisations/strings.fasl: \
		lib/vicare/crypto/randomisations/strings.sls \
		lib/vicare/crypto/randomisations.fasl \
		lib/vicare/containers/strings/low.fasl \
		lib/vicare/containers/strings.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_crypto_randomisations_strings_fasldir = $(bundledlibsdir)/vicare/crypto/randomisations
nodist_lib_vicare_crypto_randomisations_strings_fasl_DATA = lib/vicare/crypto/randomisations/strings.fasl
EXTRA_DIST += lib/vicare/crypto/randomisations/strings.sls
CLEANFILES += lib/vicare/crypto/randomisations/strings.fasl

lib/vicare/containers/strings/low.fasl: \
		lib/vicare/containers/strings/low.sls \
		lib/vicare/containers/char-sets.fasl \
		lib/vicare/containers/knuth-morris-pratt.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_strings_low_fasldir = $(bundledlibsdir)/vicare/containers/strings
nodist_lib_vicare_containers_strings_low_fasl_DATA = lib/vicare/containers/strings/low.fasl
EXTRA_DIST += lib/vicare/containers/strings/low.sls
CLEANFILES += lib/vicare/containers/strings/low.fasl

lib/vicare/containers/char-sets.fasl: \
		lib/vicare/containers/char-sets.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_char_sets_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_char_sets_fasl_DATA = lib/vicare/containers/char-sets.fasl
EXTRA_DIST += lib/vicare/containers/char-sets.sls
CLEANFILES += lib/vicare/containers/char-sets.fasl

lib/vicare/containers/knuth-morris-pratt.fasl: \
		lib/vicare/containers/knuth-morris-pratt.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_knuth_morris_pratt_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_knuth_morris_pratt_fasl_DATA = lib/vicare/containers/knuth-morris-pratt.fasl
EXTRA_DIST += lib/vicare/containers/knuth-morris-pratt.sls
CLEANFILES += lib/vicare/containers/knuth-morris-pratt.fasl

lib/vicare/containers/strings.fasl: \
		lib/vicare/containers/strings.sls \
		lib/vicare/containers/strings/low.fasl \
		lib/vicare/containers/auxiliary-syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_strings_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_strings_fasl_DATA = lib/vicare/containers/strings.fasl
EXTRA_DIST += lib/vicare/containers/strings.sls
CLEANFILES += lib/vicare/containers/strings.fasl

lib/vicare/containers/auxiliary-syntaxes.fasl: \
		lib/vicare/containers/auxiliary-syntaxes.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_auxiliary_syntaxes_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_auxiliary_syntaxes_fasl_DATA = lib/vicare/containers/auxiliary-syntaxes.fasl
EXTRA_DIST += lib/vicare/containers/auxiliary-syntaxes.sls
CLEANFILES += lib/vicare/containers/auxiliary-syntaxes.fasl

lib/vicare/crypto/randomisations/vectors.fasl: \
		lib/vicare/crypto/randomisations/vectors.sls \
		lib/vicare/crypto/randomisations.fasl \
		lib/vicare/containers/vectors/low.fasl \
		lib/vicare/containers/vectors.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_crypto_randomisations_vectors_fasldir = $(bundledlibsdir)/vicare/crypto/randomisations
nodist_lib_vicare_crypto_randomisations_vectors_fasl_DATA = lib/vicare/crypto/randomisations/vectors.fasl
EXTRA_DIST += lib/vicare/crypto/randomisations/vectors.sls
CLEANFILES += lib/vicare/crypto/randomisations/vectors.fasl

lib/vicare/containers/vectors/low.fasl: \
		lib/vicare/containers/vectors/low.sls \
		lib/vicare/containers/knuth-morris-pratt.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_vectors_low_fasldir = $(bundledlibsdir)/vicare/containers/vectors
nodist_lib_vicare_containers_vectors_low_fasl_DATA = lib/vicare/containers/vectors/low.fasl
EXTRA_DIST += lib/vicare/containers/vectors/low.sls
CLEANFILES += lib/vicare/containers/vectors/low.fasl

lib/vicare/containers/vectors.fasl: \
		lib/vicare/containers/vectors.sls \
		lib/vicare/containers/vectors/low.fasl \
		lib/vicare/containers/auxiliary-syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_vectors_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_vectors_fasl_DATA = lib/vicare/containers/vectors.fasl
EXTRA_DIST += lib/vicare/containers/vectors.sls
CLEANFILES += lib/vicare/containers/vectors.fasl

lib/vicare/numerics/constants.fasl: \
		lib/vicare/numerics/constants.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_numerics_constants_fasldir = $(bundledlibsdir)/vicare/numerics
nodist_lib_vicare_numerics_constants_fasl_DATA = lib/vicare/numerics/constants.fasl
EXTRA_DIST += lib/vicare/numerics/constants.sls
CLEANFILES += lib/vicare/numerics/constants.fasl

lib/vicare/numerics/flonum-parser.fasl: \
		lib/vicare/numerics/flonum-parser.sls \
		lib/vicare/language-extensions/syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_numerics_flonum_parser_fasldir = $(bundledlibsdir)/vicare/numerics
nodist_lib_vicare_numerics_flonum_parser_fasl_DATA = lib/vicare/numerics/flonum-parser.fasl
EXTRA_DIST += lib/vicare/numerics/flonum-parser.sls
CLEANFILES += lib/vicare/numerics/flonum-parser.fasl

lib/vicare/numerics/flonum-formatter.fasl: \
		lib/vicare/numerics/flonum-formatter.sls \
		lib/vicare/language-extensions/syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_numerics_flonum_formatter_fasldir = $(bundledlibsdir)/vicare/numerics
nodist_lib_vicare_numerics_flonum_formatter_fasl_DATA = lib/vicare/numerics/flonum-formatter.fasl
EXTRA_DIST += lib/vicare/numerics/flonum-formatter.sls
CLEANFILES += lib/vicare/numerics/flonum-formatter.fasl

lib/vicare/containers/bytevectors.fasl: \
		lib/vicare/containers/bytevectors.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_bytevectors_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_bytevectors_fasl_DATA = lib/vicare/containers/bytevectors.fasl
EXTRA_DIST += lib/vicare/containers/bytevectors.sls
CLEANFILES += lib/vicare/containers/bytevectors.fasl

lib/vicare/containers/weak-hashtables.fasl: \
		lib/vicare/containers/weak-hashtables.sls \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/language-extensions/syntaxes.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_weak_hashtables_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_weak_hashtables_fasl_DATA = lib/vicare/containers/weak-hashtables.fasl
EXTRA_DIST += lib/vicare/containers/weak-hashtables.sls
CLEANFILES += lib/vicare/containers/weak-hashtables.fasl

lib/vicare/containers/object-properties.fasl: \
		lib/vicare/containers/object-properties.sls \
		lib/vicare/containers/weak-hashtables.fasl \
		lib/vicare/language-extensions/sentinels.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_object_properties_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_object_properties_fasl_DATA = lib/vicare/containers/object-properties.fasl
EXTRA_DIST += lib/vicare/containers/object-properties.sls
CLEANFILES += lib/vicare/containers/object-properties.fasl

lib/vicare/containers/bytevector-compounds/core.fasl: \
		lib/vicare/containers/bytevector-compounds/core.sls \
		lib/vicare/language-extensions/syntaxes.fasl \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_bytevector_compounds_core_fasldir = $(bundledlibsdir)/vicare/containers/bytevector-compounds
nodist_lib_vicare_containers_bytevector_compounds_core_fasl_DATA = lib/vicare/containers/bytevector-compounds/core.fasl
EXTRA_DIST += lib/vicare/containers/bytevector-compounds/core.sls
CLEANFILES += lib/vicare/containers/bytevector-compounds/core.fasl

lib/vicare/containers/bytevector-compounds.fasl: \
		lib/vicare/containers/bytevector-compounds.sls \
		lib/vicare/containers/bytevector-compounds/core.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_bytevector_compounds_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_bytevector_compounds_fasl_DATA = lib/vicare/containers/bytevector-compounds.fasl
EXTRA_DIST += lib/vicare/containers/bytevector-compounds.sls
CLEANFILES += lib/vicare/containers/bytevector-compounds.fasl

lib/vicare/containers/bytevector-compounds/unsafe.fasl: \
		lib/vicare/containers/bytevector-compounds/unsafe.sls \
		lib/vicare/containers/bytevector-compounds/core.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_bytevector_compounds_unsafe_fasldir = $(bundledlibsdir)/vicare/containers/bytevector-compounds
nodist_lib_vicare_containers_bytevector_compounds_unsafe_fasl_DATA = lib/vicare/containers/bytevector-compounds/unsafe.fasl
EXTRA_DIST += lib/vicare/containers/bytevector-compounds/unsafe.sls
CLEANFILES += lib/vicare/containers/bytevector-compounds/unsafe.fasl

lib/vicare/containers/char-sets/blocks.fasl: \
		lib/vicare/containers/char-sets/blocks.sls \
		lib/vicare/containers/char-sets.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_char_sets_blocks_fasldir = $(bundledlibsdir)/vicare/containers/char-sets
nodist_lib_vicare_containers_char_sets_blocks_fasl_DATA = lib/vicare/containers/char-sets/blocks.fasl
EXTRA_DIST += lib/vicare/containers/char-sets/blocks.sls
CLEANFILES += lib/vicare/containers/char-sets/blocks.fasl

lib/vicare/containers/char-sets/categories.fasl: \
		lib/vicare/containers/char-sets/categories.sls \
		lib/vicare/containers/char-sets.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_char_sets_categories_fasldir = $(bundledlibsdir)/vicare/containers/char-sets
nodist_lib_vicare_containers_char_sets_categories_fasl_DATA = lib/vicare/containers/char-sets/categories.fasl
EXTRA_DIST += lib/vicare/containers/char-sets/categories.sls
CLEANFILES += lib/vicare/containers/char-sets/categories.fasl

lib/vicare/containers/lists/stx.fasl: \
		lib/vicare/containers/lists/stx.sls \
		lib/vicare/containers/lists/low.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_lists_stx_fasldir = $(bundledlibsdir)/vicare/containers/lists
nodist_lib_vicare_containers_lists_stx_fasl_DATA = lib/vicare/containers/lists/stx.fasl
EXTRA_DIST += lib/vicare/containers/lists/stx.sls
CLEANFILES += lib/vicare/containers/lists/stx.fasl

lib/vicare/containers/lists/low.fasl: \
		lib/vicare/containers/lists/low.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_lists_low_fasldir = $(bundledlibsdir)/vicare/containers/lists
nodist_lib_vicare_containers_lists_low_fasl_DATA = lib/vicare/containers/lists/low.fasl
EXTRA_DIST += lib/vicare/containers/lists/low.sls
CLEANFILES += lib/vicare/containers/lists/low.fasl

lib/vicare/containers/lists.fasl: \
		lib/vicare/containers/lists.sls \
		lib/vicare/containers/lists/stx.fasl \
		lib/vicare/containers/lists/low.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_lists_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_lists_fasl_DATA = lib/vicare/containers/lists.fasl
EXTRA_DIST += lib/vicare/containers/lists.sls
CLEANFILES += lib/vicare/containers/lists.fasl

lib/vicare/containers/strings/rabin-karp.fasl: \
		lib/vicare/containers/strings/rabin-karp.sls \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/language-extensions/infix.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_strings_rabin_karp_fasldir = $(bundledlibsdir)/vicare/containers/strings
nodist_lib_vicare_containers_strings_rabin_karp_fasl_DATA = lib/vicare/containers/strings/rabin-karp.fasl
EXTRA_DIST += lib/vicare/containers/strings/rabin-karp.sls
CLEANFILES += lib/vicare/containers/strings/rabin-karp.fasl

lib/vicare/containers/levenshtein.fasl: \
		lib/vicare/containers/levenshtein.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_levenshtein_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_levenshtein_fasl_DATA = lib/vicare/containers/levenshtein.fasl
EXTRA_DIST += lib/vicare/containers/levenshtein.sls
CLEANFILES += lib/vicare/containers/levenshtein.fasl

lib/vicare/containers/one-dimension-co.fasl: \
		lib/vicare/containers/one-dimension-co.sls \
		lib/vicare/containers/lists.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_one_dimension_co_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_one_dimension_co_fasl_DATA = lib/vicare/containers/one-dimension-co.fasl
EXTRA_DIST += lib/vicare/containers/one-dimension-co.sls
CLEANFILES += lib/vicare/containers/one-dimension-co.fasl

lib/vicare/containers/one-dimension-cc.fasl: \
		lib/vicare/containers/one-dimension-cc.sls \
		lib/vicare/containers/lists.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_one_dimension_cc_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_one_dimension_cc_fasl_DATA = lib/vicare/containers/one-dimension-cc.fasl
EXTRA_DIST += lib/vicare/containers/one-dimension-cc.sls
CLEANFILES += lib/vicare/containers/one-dimension-cc.fasl

lib/vicare/containers/bytevectors/u8.fasl: \
		lib/vicare/containers/bytevectors/u8.sls \
		lib/vicare/language-extensions/ascii-chars.fasl \
		lib/vicare/containers/bytevectors/u8low.fasl \
		lib/vicare/containers/bytevectors/generic.fasl \
		lib/vicare/containers/auxiliary-syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_bytevectors_u8_fasldir = $(bundledlibsdir)/vicare/containers/bytevectors
nodist_lib_vicare_containers_bytevectors_u8_fasl_DATA = lib/vicare/containers/bytevectors/u8.fasl
EXTRA_DIST += lib/vicare/containers/bytevectors/u8.sls
CLEANFILES += lib/vicare/containers/bytevectors/u8.fasl

lib/vicare/containers/bytevectors/u8low.fasl: \
		lib/vicare/containers/bytevectors/u8low.sls \
		lib/vicare/containers/bytevectors/generic-low.fasl \
		lib/vicare/containers/char-sets.fasl \
		lib/vicare/containers/knuth-morris-pratt.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_bytevectors_u8low_fasldir = $(bundledlibsdir)/vicare/containers/bytevectors
nodist_lib_vicare_containers_bytevectors_u8low_fasl_DATA = lib/vicare/containers/bytevectors/u8low.fasl
EXTRA_DIST += lib/vicare/containers/bytevectors/u8low.sls
CLEANFILES += lib/vicare/containers/bytevectors/u8low.fasl

lib/vicare/containers/bytevectors/generic-low.fasl: \
		lib/vicare/containers/bytevectors/generic-low.sls \
		lib/vicare/containers/auxiliary-syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_bytevectors_generic_low_fasldir = $(bundledlibsdir)/vicare/containers/bytevectors
nodist_lib_vicare_containers_bytevectors_generic_low_fasl_DATA = lib/vicare/containers/bytevectors/generic-low.fasl
EXTRA_DIST += lib/vicare/containers/bytevectors/generic-low.sls
CLEANFILES += lib/vicare/containers/bytevectors/generic-low.fasl

lib/vicare/containers/bytevectors/generic.fasl: \
		lib/vicare/containers/bytevectors/generic.sls \
		lib/vicare/containers/auxiliary-syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_bytevectors_generic_fasldir = $(bundledlibsdir)/vicare/containers/bytevectors
nodist_lib_vicare_containers_bytevectors_generic_fasl_DATA = lib/vicare/containers/bytevectors/generic.fasl
EXTRA_DIST += lib/vicare/containers/bytevectors/generic.sls
CLEANFILES += lib/vicare/containers/bytevectors/generic.fasl

lib/vicare/containers/bytevectors/s8.fasl: \
		lib/vicare/containers/bytevectors/s8.sls \
		lib/vicare/language-extensions/ascii-chars.fasl \
		lib/vicare/containers/bytevectors/s8low.fasl \
		lib/vicare/containers/bytevectors/generic.fasl \
		lib/vicare/containers/auxiliary-syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_bytevectors_s8_fasldir = $(bundledlibsdir)/vicare/containers/bytevectors
nodist_lib_vicare_containers_bytevectors_s8_fasl_DATA = lib/vicare/containers/bytevectors/s8.fasl
EXTRA_DIST += lib/vicare/containers/bytevectors/s8.sls
CLEANFILES += lib/vicare/containers/bytevectors/s8.fasl

lib/vicare/containers/bytevectors/s8low.fasl: \
		lib/vicare/containers/bytevectors/s8low.sls \
		lib/vicare/containers/bytevectors/generic-low.fasl \
		lib/vicare/containers/char-sets.fasl \
		lib/vicare/containers/knuth-morris-pratt.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_bytevectors_s8low_fasldir = $(bundledlibsdir)/vicare/containers/bytevectors
nodist_lib_vicare_containers_bytevectors_s8low_fasl_DATA = lib/vicare/containers/bytevectors/s8low.fasl
EXTRA_DIST += lib/vicare/containers/bytevectors/s8low.sls
CLEANFILES += lib/vicare/containers/bytevectors/s8low.fasl

lib/vicare/containers/arrays.fasl: \
		lib/vicare/containers/arrays.sls \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_arrays_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_arrays_fasl_DATA = lib/vicare/containers/arrays.fasl
EXTRA_DIST += lib/vicare/containers/arrays.sls
CLEANFILES += lib/vicare/containers/arrays.fasl

lib/vicare/containers/stacks.fasl: \
		lib/vicare/containers/stacks.sls \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_stacks_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_stacks_fasl_DATA = lib/vicare/containers/stacks.fasl
EXTRA_DIST += lib/vicare/containers/stacks.sls
CLEANFILES += lib/vicare/containers/stacks.fasl

lib/vicare/containers/queues.fasl: \
		lib/vicare/containers/queues.sls \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_containers_queues_fasldir = $(bundledlibsdir)/vicare/containers
nodist_lib_vicare_containers_queues_fasl_DATA = lib/vicare/containers/queues.fasl
EXTRA_DIST += lib/vicare/containers/queues.sls
CLEANFILES += lib/vicare/containers/queues.fasl

lib/vicare/parser-tools/silex/lexer.fasl: \
		lib/vicare/parser-tools/silex/lexer.sls \
		lib/vicare/parser-tools/silex/input-system.fasl \
		lib/vicare/parser-tools/silex/code-lexer-driver.fasl \
		lib/vicare/parser-tools/silex/tree-lexer-driver.fasl \
		lib/vicare/parser-tools/silex/char-lexer-driver.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_lexer_fasldir = $(bundledlibsdir)/vicare/parser-tools/silex
nodist_lib_vicare_parser_tools_silex_lexer_fasl_DATA = lib/vicare/parser-tools/silex/lexer.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex/lexer.sls
CLEANFILES += lib/vicare/parser-tools/silex/lexer.fasl

lib/vicare/parser-tools/silex/input-system.fasl: \
		lib/vicare/parser-tools/silex/input-system.sls \
		lib/vicare/language-extensions/makers.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_input_system_fasldir = $(bundledlibsdir)/vicare/parser-tools/silex
nodist_lib_vicare_parser_tools_silex_input_system_fasl_DATA = lib/vicare/parser-tools/silex/input-system.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex/input-system.sls
CLEANFILES += lib/vicare/parser-tools/silex/input-system.fasl

lib/vicare/parser-tools/silex/code-lexer-driver.fasl: \
		lib/vicare/parser-tools/silex/code-lexer-driver.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_code_lexer_driver_fasldir = $(bundledlibsdir)/vicare/parser-tools/silex
nodist_lib_vicare_parser_tools_silex_code_lexer_driver_fasl_DATA = lib/vicare/parser-tools/silex/code-lexer-driver.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex/code-lexer-driver.sls
CLEANFILES += lib/vicare/parser-tools/silex/code-lexer-driver.fasl

lib/vicare/parser-tools/silex/tree-lexer-driver.fasl: \
		lib/vicare/parser-tools/silex/tree-lexer-driver.sls \
		lib/vicare/parser-tools/silex/input-system.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_tree_lexer_driver_fasldir = $(bundledlibsdir)/vicare/parser-tools/silex
nodist_lib_vicare_parser_tools_silex_tree_lexer_driver_fasl_DATA = lib/vicare/parser-tools/silex/tree-lexer-driver.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex/tree-lexer-driver.sls
CLEANFILES += lib/vicare/parser-tools/silex/tree-lexer-driver.fasl

lib/vicare/parser-tools/silex/char-lexer-driver.fasl: \
		lib/vicare/parser-tools/silex/char-lexer-driver.sls \
		lib/vicare/parser-tools/silex/input-system.fasl \
		lib/vicare/parser-tools/silex/tree-lexer-driver.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_char_lexer_driver_fasldir = $(bundledlibsdir)/vicare/parser-tools/silex
nodist_lib_vicare_parser_tools_silex_char_lexer_driver_fasl_DATA = lib/vicare/parser-tools/silex/char-lexer-driver.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex/char-lexer-driver.sls
CLEANFILES += lib/vicare/parser-tools/silex/char-lexer-driver.fasl

lib/vicare/parser-tools/silex.fasl: \
		lib/vicare/parser-tools/silex.sls \
		lib/vicare/parser-tools/silex/lexer.fasl \
		lib/vicare/parser-tools/silex/semantic.fasl \
		lib/vicare/parser-tools/silex/action-l.fasl \
		lib/vicare/parser-tools/silex/class-l.fasl \
		lib/vicare/parser-tools/silex/macro-l.fasl \
		lib/vicare/parser-tools/silex/regexp-l.fasl \
		lib/vicare/parser-tools/silex/string-l.fasl \
		lib/vicare/parser-tools/silex/nested-comment-l.fasl \
		lib/vicare/language-extensions/makers.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_fasldir = $(bundledlibsdir)/vicare/parser-tools
nodist_lib_vicare_parser_tools_silex_fasl_DATA = lib/vicare/parser-tools/silex.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex.sls
CLEANFILES += lib/vicare/parser-tools/silex.fasl

lib/vicare/parser-tools/silex/semantic.fasl: \
		lib/vicare/parser-tools/silex/semantic.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_semantic_fasldir = $(bundledlibsdir)/vicare/parser-tools/silex
nodist_lib_vicare_parser_tools_silex_semantic_fasl_DATA = lib/vicare/parser-tools/silex/semantic.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex/semantic.sls
CLEANFILES += lib/vicare/parser-tools/silex/semantic.fasl

lib/vicare/parser-tools/silex/action-l.fasl: \
		lib/vicare/parser-tools/silex/action-l.sls \
		lib/vicare/parser-tools/silex/input-system.fasl \
		lib/vicare/parser-tools/silex/semantic.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_action_l_fasldir = $(bundledlibsdir)/vicare/parser-tools/silex
nodist_lib_vicare_parser_tools_silex_action_l_fasl_DATA = lib/vicare/parser-tools/silex/action-l.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex/action-l.sls
CLEANFILES += lib/vicare/parser-tools/silex/action-l.fasl

lib/vicare/parser-tools/silex/class-l.fasl: \
		lib/vicare/parser-tools/silex/class-l.sls \
		lib/vicare/parser-tools/silex/input-system.fasl \
		lib/vicare/parser-tools/silex/semantic.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_class_l_fasldir = $(bundledlibsdir)/vicare/parser-tools/silex
nodist_lib_vicare_parser_tools_silex_class_l_fasl_DATA = lib/vicare/parser-tools/silex/class-l.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex/class-l.sls
CLEANFILES += lib/vicare/parser-tools/silex/class-l.fasl

lib/vicare/parser-tools/silex/macro-l.fasl: \
		lib/vicare/parser-tools/silex/macro-l.sls \
		lib/vicare/parser-tools/silex/input-system.fasl \
		lib/vicare/parser-tools/silex/semantic.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_macro_l_fasldir = $(bundledlibsdir)/vicare/parser-tools/silex
nodist_lib_vicare_parser_tools_silex_macro_l_fasl_DATA = lib/vicare/parser-tools/silex/macro-l.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex/macro-l.sls
CLEANFILES += lib/vicare/parser-tools/silex/macro-l.fasl

lib/vicare/parser-tools/silex/regexp-l.fasl: \
		lib/vicare/parser-tools/silex/regexp-l.sls \
		lib/vicare/parser-tools/silex/input-system.fasl \
		lib/vicare/parser-tools/silex/semantic.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_regexp_l_fasldir = $(bundledlibsdir)/vicare/parser-tools/silex
nodist_lib_vicare_parser_tools_silex_regexp_l_fasl_DATA = lib/vicare/parser-tools/silex/regexp-l.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex/regexp-l.sls
CLEANFILES += lib/vicare/parser-tools/silex/regexp-l.fasl

lib/vicare/parser-tools/silex/string-l.fasl: \
		lib/vicare/parser-tools/silex/string-l.sls \
		lib/vicare/parser-tools/silex/input-system.fasl \
		lib/vicare/parser-tools/silex/semantic.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_string_l_fasldir = $(bundledlibsdir)/vicare/parser-tools/silex
nodist_lib_vicare_parser_tools_silex_string_l_fasl_DATA = lib/vicare/parser-tools/silex/string-l.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex/string-l.sls
CLEANFILES += lib/vicare/parser-tools/silex/string-l.fasl

lib/vicare/parser-tools/silex/nested-comment-l.fasl: \
		lib/vicare/parser-tools/silex/nested-comment-l.sls \
		lib/vicare/parser-tools/silex/input-system.fasl \
		lib/vicare/parser-tools/silex/semantic.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_nested_comment_l_fasldir = $(bundledlibsdir)/vicare/parser-tools/silex
nodist_lib_vicare_parser_tools_silex_nested_comment_l_fasl_DATA = lib/vicare/parser-tools/silex/nested-comment-l.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex/nested-comment-l.sls
CLEANFILES += lib/vicare/parser-tools/silex/nested-comment-l.fasl

lib/vicare/parser-tools/silex/utilities.fasl: \
		lib/vicare/parser-tools/silex/utilities.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_silex_utilities_fasldir = $(bundledlibsdir)/vicare/parser-tools/silex
nodist_lib_vicare_parser_tools_silex_utilities_fasl_DATA = lib/vicare/parser-tools/silex/utilities.fasl
EXTRA_DIST += lib/vicare/parser-tools/silex/utilities.sls
CLEANFILES += lib/vicare/parser-tools/silex/utilities.fasl

lib/vicare/parser-tools/unix-pathnames.fasl: \
		lib/vicare/parser-tools/unix-pathnames.sls \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_tools_unix_pathnames_fasldir = $(bundledlibsdir)/vicare/parser-tools
nodist_lib_vicare_parser_tools_unix_pathnames_fasl_DATA = lib/vicare/parser-tools/unix-pathnames.fasl
EXTRA_DIST += lib/vicare/parser-tools/unix-pathnames.sls
CLEANFILES += lib/vicare/parser-tools/unix-pathnames.fasl

lib/vicare/net/channels.fasl: \
		lib/vicare/net/channels.sls \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/language-extensions/syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_net_channels_fasldir = $(bundledlibsdir)/vicare/net
nodist_lib_vicare_net_channels_fasl_DATA = lib/vicare/net/channels.fasl
EXTRA_DIST += lib/vicare/net/channels.sls
CLEANFILES += lib/vicare/net/channels.fasl

lib/vicare/ffi.fasl: \
		lib/vicare/ffi.sls \
		lib/vicare/platform/errno.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_LIBFFI
lib_vicare_ffi_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_ffi_fasl_DATA = lib/vicare/ffi.fasl
EXTRA_DIST += lib/vicare/ffi.sls
CLEANFILES += lib/vicare/ffi.fasl
endif

lib/vicare/ffi/foreign-pointer-wrapper.fasl: \
		lib/vicare/ffi/foreign-pointer-wrapper.sls \
		lib/vicare/language-extensions/syntaxes.fasl \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_LIBFFI
lib_vicare_ffi_foreign_pointer_wrapper_fasldir = $(bundledlibsdir)/vicare/ffi
nodist_lib_vicare_ffi_foreign_pointer_wrapper_fasl_DATA = lib/vicare/ffi/foreign-pointer-wrapper.fasl
EXTRA_DIST += lib/vicare/ffi/foreign-pointer-wrapper.sls
CLEANFILES += lib/vicare/ffi/foreign-pointer-wrapper.fasl
endif

lib/vicare/iconv.fasl: \
		lib/vicare/iconv.sls \
		lib/vicare/language-extensions/syntaxes.fasl \
		lib/vicare/platform/constants.fasl \
		lib/vicare/unsafe/capi.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_LIBICONV
lib_vicare_iconv_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_iconv_fasl_DATA = lib/vicare/iconv.fasl
EXTRA_DIST += lib/vicare/iconv.sls
CLEANFILES += lib/vicare/iconv.fasl
endif

lib/vicare/posix.fasl: \
		lib/vicare/posix.sls \
		lib/vicare/language-extensions/syntaxes.fasl \
		lib/vicare/platform/constants.fasl \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/arguments/general-c-buffers.fasl \
		lib/vicare/unsafe/capi.fasl \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/platform/words.fasl \
		lib/vicare/language-extensions/cond-expand.fasl \
		lib/vicare/containers/weak-hashtables.fasl \
		lib/vicare/platform/features.fasl \
		lib/vicare/language-extensions/cond-expand/helpers.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_POSIX
lib_vicare_posix_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_posix_fasl_DATA = lib/vicare/posix.fasl
EXTRA_DIST += lib/vicare/posix.sls
CLEANFILES += lib/vicare/posix.fasl
endif

lib/vicare/posix/pid-files.fasl: \
		lib/vicare/posix/pid-files.sls \
		lib/vicare/posix.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_POSIX
lib_vicare_posix_pid_files_fasldir = $(bundledlibsdir)/vicare/posix
nodist_lib_vicare_posix_pid_files_fasl_DATA = lib/vicare/posix/pid-files.fasl
EXTRA_DIST += lib/vicare/posix/pid-files.sls
CLEANFILES += lib/vicare/posix/pid-files.fasl
endif

lib/vicare/posix/lock-pid-files.fasl: \
		lib/vicare/posix/lock-pid-files.sls \
		lib/vicare/posix.fasl \
		lib/vicare/platform/constants.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_POSIX
lib_vicare_posix_lock_pid_files_fasldir = $(bundledlibsdir)/vicare/posix
nodist_lib_vicare_posix_lock_pid_files_fasl_DATA = lib/vicare/posix/lock-pid-files.fasl
EXTRA_DIST += lib/vicare/posix/lock-pid-files.sls
CLEANFILES += lib/vicare/posix/lock-pid-files.fasl
endif

lib/vicare/posix/log-files.fasl: \
		lib/vicare/posix/log-files.sls \
		lib/vicare/posix.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_POSIX
lib_vicare_posix_log_files_fasldir = $(bundledlibsdir)/vicare/posix
nodist_lib_vicare_posix_log_files_fasl_DATA = lib/vicare/posix/log-files.fasl
EXTRA_DIST += lib/vicare/posix/log-files.sls
CLEANFILES += lib/vicare/posix/log-files.fasl
endif

lib/vicare/posix/daemonisations.fasl: \
		lib/vicare/posix/daemonisations.sls \
		lib/vicare/posix.fasl \
		lib/vicare/platform/constants.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_POSIX
lib_vicare_posix_daemonisations_fasldir = $(bundledlibsdir)/vicare/posix
nodist_lib_vicare_posix_daemonisations_fasl_DATA = lib/vicare/posix/daemonisations.fasl
EXTRA_DIST += lib/vicare/posix/daemonisations.sls
CLEANFILES += lib/vicare/posix/daemonisations.fasl
endif

lib/vicare/posix/simple-event-loop.fasl: \
		lib/vicare/posix/simple-event-loop.sls \
		lib/vicare/posix.fasl \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/language-extensions/syntaxes.fasl \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/platform/constants.fasl \
		lib/vicare/platform/utilities.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_POSIX
lib_vicare_posix_simple_event_loop_fasldir = $(bundledlibsdir)/vicare/posix
nodist_lib_vicare_posix_simple_event_loop_fasl_DATA = lib/vicare/posix/simple-event-loop.fasl
EXTRA_DIST += lib/vicare/posix/simple-event-loop.sls
CLEANFILES += lib/vicare/posix/simple-event-loop.fasl
endif

lib/vicare/posix/tcp-server-sockets.fasl: \
		lib/vicare/posix/tcp-server-sockets.sls \
		lib/vicare/posix.fasl \
		lib/vicare/platform/constants.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_POSIX
lib_vicare_posix_tcp_server_sockets_fasldir = $(bundledlibsdir)/vicare/posix
nodist_lib_vicare_posix_tcp_server_sockets_fasl_DATA = lib/vicare/posix/tcp-server-sockets.fasl
EXTRA_DIST += lib/vicare/posix/tcp-server-sockets.sls
CLEANFILES += lib/vicare/posix/tcp-server-sockets.fasl
endif

lib/vicare/glibc.fasl: \
		lib/vicare/glibc.sls \
		lib/vicare/posix.fasl \
		lib/vicare/language-extensions/syntaxes.fasl \
		lib/vicare/platform/constants.fasl \
		lib/vicare/unsafe/capi.fasl \
		lib/vicare/platform/words.fasl \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/language-extensions/cond-expand.fasl \
		lib/vicare/platform/features.fasl \
		lib/vicare/language-extensions/cond-expand/helpers.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_GLIBC
lib_vicare_glibc_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_glibc_fasl_DATA = lib/vicare/glibc.fasl
EXTRA_DIST += lib/vicare/glibc.sls
CLEANFILES += lib/vicare/glibc.fasl
endif

lib/vicare/gcc.fasl: \
		lib/vicare/gcc.sls \
		lib/vicare/ffi.fasl \
		lib/vicare/posix.fasl \
		lib/vicare/glibc.fasl \
		lib/vicare/platform/constants.fasl \
		lib/vicare/language-extensions/syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_LIBFFI
if WANT_POSIX
if WANT_GLIBC
lib_vicare_gcc_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_gcc_fasl_DATA = lib/vicare/gcc.fasl
EXTRA_DIST += lib/vicare/gcc.sls
CLEANFILES += lib/vicare/gcc.fasl
endif
endif
endif

lib/vicare/linux.fasl: \
		lib/vicare/linux.sls \
		lib/vicare/language-extensions/syntaxes.fasl \
		lib/vicare/platform/constants.fasl \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/arguments/general-c-buffers.fasl \
		lib/vicare/platform/words.fasl \
		lib/vicare/posix.fasl \
		lib/vicare/unsafe/capi.fasl \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/language-extensions/cond-expand.fasl \
		lib/vicare/platform/features.fasl \
		lib/vicare/language-extensions/cond-expand/helpers.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_POSIX
if WANT_LINUX
lib_vicare_linux_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_linux_fasl_DATA = lib/vicare/linux.fasl
EXTRA_DIST += lib/vicare/linux.sls
CLEANFILES += lib/vicare/linux.fasl
endif
endif

lib/vicare/readline.fasl: \
		lib/vicare/readline.sls \
		lib/vicare/language-extensions/syntaxes.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_READLINE
lib_vicare_readline_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_readline_fasl_DATA = lib/vicare/readline.fasl
EXTRA_DIST += lib/vicare/readline.sls
CLEANFILES += lib/vicare/readline.fasl
endif

lib/vicare/assembler/inspection.fasl: \
		lib/vicare/assembler/inspection.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_assembler_inspection_fasldir = $(bundledlibsdir)/vicare/assembler
nodist_lib_vicare_assembler_inspection_fasl_DATA = lib/vicare/assembler/inspection.fasl
EXTRA_DIST += lib/vicare/assembler/inspection.sls
CLEANFILES += lib/vicare/assembler/inspection.fasl

lib/vicare/debugging/compiler.fasl: \
		lib/vicare/debugging/compiler.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_debugging_compiler_fasldir = $(bundledlibsdir)/vicare/debugging
nodist_lib_vicare_debugging_compiler_fasl_DATA = lib/vicare/debugging/compiler.fasl
EXTRA_DIST += lib/vicare/debugging/compiler.sls
CLEANFILES += lib/vicare/debugging/compiler.fasl

lib/vicare/parser-logic.fasl: \
		lib/vicare/parser-logic.sls \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_parser_logic_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_parser_logic_fasl_DATA = lib/vicare/parser-logic.fasl
EXTRA_DIST += lib/vicare/parser-logic.sls
CLEANFILES += lib/vicare/parser-logic.fasl

lib/vicare/irregex.fasl: \
		lib/vicare/irregex.sls \
		lib/vicare/irregex/compat.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_irregex_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_irregex_fasl_DATA = lib/vicare/irregex.fasl
EXTRA_DIST += lib/vicare/irregex.sls
CLEANFILES += lib/vicare/irregex.fasl

lib/vicare/irregex/compat.fasl: \
		lib/vicare/irregex/compat.vicare.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_irregex_compat_fasldir = $(bundledlibsdir)/vicare/irregex
nodist_lib_vicare_irregex_compat_fasl_DATA = lib/vicare/irregex/compat.fasl
EXTRA_DIST += lib/vicare/irregex/compat.vicare.sls
CLEANFILES += lib/vicare/irregex/compat.fasl

lib/vicare/pregexp.fasl: \
		lib/vicare/pregexp.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_pregexp_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_pregexp_fasl_DATA = lib/vicare/pregexp.fasl
EXTRA_DIST += lib/vicare/pregexp.sls
CLEANFILES += lib/vicare/pregexp.fasl

lib/vicare/getopts.fasl: \
		lib/vicare/getopts.sls \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/language-extensions/syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_getopts_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_getopts_fasl_DATA = lib/vicare/getopts.fasl
EXTRA_DIST += lib/vicare/getopts.sls
CLEANFILES += lib/vicare/getopts.fasl

lib/vicare/formations.fasl: \
		lib/vicare/formations.sls \
		lib/vicare/language-extensions/infix.fasl \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

lib_vicare_formations_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_formations_fasl_DATA = lib/vicare/formations.fasl
EXTRA_DIST += lib/vicare/formations.sls
CLEANFILES += lib/vicare/formations.fasl

lib/vicare/cre2.fasl: \
		lib/vicare/cre2.sls \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_CRE2
lib_vicare_cre2_fasldir = $(bundledlibsdir)/vicare
nodist_lib_vicare_cre2_fasl_DATA = lib/vicare/cre2.fasl
EXTRA_DIST += lib/vicare/cre2.sls
CLEANFILES += lib/vicare/cre2.fasl
endif

lib/srfi/%3a0.fasl: \
		lib/srfi/%3a0.sls \
		lib/srfi/%3a0/cond-expand.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a0_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a0_fasl_DATA = lib/srfi/%3a0.fasl
EXTRA_DIST += lib/srfi/%3a0.sls
CLEANFILES += lib/srfi/%3a0.fasl
endif

lib/srfi/%3a0/cond-expand.fasl: \
		lib/srfi/%3a0/cond-expand.sls \
		lib/vicare/language-extensions/cond-expand/registry.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a0_cond_expand_fasldir = $(bundledlibsdir)/srfi/%3a0
nodist_lib_srfi__3a0_cond_expand_fasl_DATA = lib/srfi/%3a0/cond-expand.fasl
EXTRA_DIST += lib/srfi/%3a0/cond-expand.sls
CLEANFILES += lib/srfi/%3a0/cond-expand.fasl
endif

lib/srfi/%3a1.fasl: \
		lib/srfi/%3a1.sls \
		lib/srfi/%3a1/lists.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a1_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a1_fasl_DATA = lib/srfi/%3a1.fasl
EXTRA_DIST += lib/srfi/%3a1.sls
CLEANFILES += lib/srfi/%3a1.fasl
endif

lib/srfi/%3a1/lists.fasl: \
		lib/srfi/%3a1/lists.sls \
		lib/srfi/%3a8/receive.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a1_lists_fasldir = $(bundledlibsdir)/srfi/%3a1
nodist_lib_srfi__3a1_lists_fasl_DATA = lib/srfi/%3a1/lists.fasl
EXTRA_DIST += lib/srfi/%3a1/lists.sls
CLEANFILES += lib/srfi/%3a1/lists.fasl
endif

lib/srfi/%3a8/receive.fasl: \
		lib/srfi/%3a8/receive.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a8_receive_fasldir = $(bundledlibsdir)/srfi/%3a8
nodist_lib_srfi__3a8_receive_fasl_DATA = lib/srfi/%3a8/receive.fasl
EXTRA_DIST += lib/srfi/%3a8/receive.sls
CLEANFILES += lib/srfi/%3a8/receive.fasl
endif

lib/srfi/%3a2.fasl: \
		lib/srfi/%3a2.sls \
		lib/srfi/%3a2/and-let%2a.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a2_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a2_fasl_DATA = lib/srfi/%3a2.fasl
EXTRA_DIST += lib/srfi/%3a2.sls
CLEANFILES += lib/srfi/%3a2.fasl
endif

lib/srfi/%3a2/and-let%2a.fasl: \
		lib/srfi/%3a2/and-let%2a.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a2_and_let_2a_fasldir = $(bundledlibsdir)/srfi/%3a2
nodist_lib_srfi__3a2_and_let_2a_fasl_DATA = lib/srfi/%3a2/and-let%2a.fasl
EXTRA_DIST += lib/srfi/%3a2/and-let%2a.sls
CLEANFILES += lib/srfi/%3a2/and-let%2a.fasl
endif

lib/srfi/%3a6.fasl: \
		lib/srfi/%3a6.sls \
		lib/srfi/%3a6/basic-string-ports.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a6_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a6_fasl_DATA = lib/srfi/%3a6.fasl
EXTRA_DIST += lib/srfi/%3a6.sls
CLEANFILES += lib/srfi/%3a6.fasl
endif

lib/srfi/%3a6/basic-string-ports.fasl: \
		lib/srfi/%3a6/basic-string-ports.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a6_basic_string_ports_fasldir = $(bundledlibsdir)/srfi/%3a6
nodist_lib_srfi__3a6_basic_string_ports_fasl_DATA = lib/srfi/%3a6/basic-string-ports.fasl
EXTRA_DIST += lib/srfi/%3a6/basic-string-ports.sls
CLEANFILES += lib/srfi/%3a6/basic-string-ports.fasl
endif

lib/srfi/%3a8.fasl: \
		lib/srfi/%3a8.sls \
		lib/srfi/%3a8/receive.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a8_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a8_fasl_DATA = lib/srfi/%3a8.fasl
EXTRA_DIST += lib/srfi/%3a8.sls
CLEANFILES += lib/srfi/%3a8.fasl
endif

lib/srfi/%3a9.fasl: \
		lib/srfi/%3a9.sls \
		lib/srfi/%3a9/records.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a9_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a9_fasl_DATA = lib/srfi/%3a9.fasl
EXTRA_DIST += lib/srfi/%3a9.sls
CLEANFILES += lib/srfi/%3a9.fasl
endif

lib/srfi/%3a9/records.fasl: \
		lib/srfi/%3a9/records.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a9_records_fasldir = $(bundledlibsdir)/srfi/%3a9
nodist_lib_srfi__3a9_records_fasl_DATA = lib/srfi/%3a9/records.fasl
EXTRA_DIST += lib/srfi/%3a9/records.sls
CLEANFILES += lib/srfi/%3a9/records.fasl
endif

lib/srfi/%3a11.fasl: \
		lib/srfi/%3a11.sls \
		lib/srfi/%3a11/let-values.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a11_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a11_fasl_DATA = lib/srfi/%3a11.fasl
EXTRA_DIST += lib/srfi/%3a11.sls
CLEANFILES += lib/srfi/%3a11.fasl
endif

lib/srfi/%3a11/let-values.fasl: \
		lib/srfi/%3a11/let-values.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a11_let_values_fasldir = $(bundledlibsdir)/srfi/%3a11
nodist_lib_srfi__3a11_let_values_fasl_DATA = lib/srfi/%3a11/let-values.fasl
EXTRA_DIST += lib/srfi/%3a11/let-values.sls
CLEANFILES += lib/srfi/%3a11/let-values.fasl
endif

lib/srfi/%3a13.fasl: \
		lib/srfi/%3a13.sls \
		lib/srfi/%3a13/strings.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a13_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a13_fasl_DATA = lib/srfi/%3a13.fasl
EXTRA_DIST += lib/srfi/%3a13.sls
CLEANFILES += lib/srfi/%3a13.fasl
endif

lib/srfi/%3a13/strings.fasl: \
		lib/srfi/%3a13/strings.sls \
		lib/srfi/%3a14/char-sets.fasl \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/language-extensions/syntaxes.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a13_strings_fasldir = $(bundledlibsdir)/srfi/%3a13
nodist_lib_srfi__3a13_strings_fasl_DATA = lib/srfi/%3a13/strings.fasl
EXTRA_DIST += lib/srfi/%3a13/strings.sls
CLEANFILES += lib/srfi/%3a13/strings.fasl
endif

lib/srfi/%3a14/char-sets.fasl: \
		lib/srfi/%3a14/char-sets.sls \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a14_char_sets_fasldir = $(bundledlibsdir)/srfi/%3a14
nodist_lib_srfi__3a14_char_sets_fasl_DATA = lib/srfi/%3a14/char-sets.fasl
EXTRA_DIST += lib/srfi/%3a14/char-sets.sls
CLEANFILES += lib/srfi/%3a14/char-sets.fasl
endif

lib/srfi/%3a14.fasl: \
		lib/srfi/%3a14.sls \
		lib/srfi/%3a14/char-sets.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a14_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a14_fasl_DATA = lib/srfi/%3a14.fasl
EXTRA_DIST += lib/srfi/%3a14.sls
CLEANFILES += lib/srfi/%3a14.fasl
endif

lib/srfi/%3a16.fasl: \
		lib/srfi/%3a16.sls \
		lib/srfi/%3a16/case-lambda.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a16_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a16_fasl_DATA = lib/srfi/%3a16.fasl
EXTRA_DIST += lib/srfi/%3a16.sls
CLEANFILES += lib/srfi/%3a16.fasl
endif

lib/srfi/%3a16/case-lambda.fasl: \
		lib/srfi/%3a16/case-lambda.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a16_case_lambda_fasldir = $(bundledlibsdir)/srfi/%3a16
nodist_lib_srfi__3a16_case_lambda_fasl_DATA = lib/srfi/%3a16/case-lambda.fasl
EXTRA_DIST += lib/srfi/%3a16/case-lambda.sls
CLEANFILES += lib/srfi/%3a16/case-lambda.fasl
endif

lib/srfi/%3a19.fasl: \
		lib/srfi/%3a19.sls \
		lib/srfi/%3a19/time.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a19_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a19_fasl_DATA = lib/srfi/%3a19.fasl
EXTRA_DIST += lib/srfi/%3a19.sls
CLEANFILES += lib/srfi/%3a19.fasl
endif

lib/srfi/%3a19/time.fasl: \
		lib/srfi/%3a19/time.sls \
		lib/srfi/%3a6/basic-string-ports.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a19_time_fasldir = $(bundledlibsdir)/srfi/%3a19
nodist_lib_srfi__3a19_time_fasl_DATA = lib/srfi/%3a19/time.fasl
EXTRA_DIST += lib/srfi/%3a19/time.sls
CLEANFILES += lib/srfi/%3a19/time.fasl
endif

lib/srfi/%3a23.fasl: \
		lib/srfi/%3a23.sls \
		lib/srfi/%3a23/error.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a23_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a23_fasl_DATA = lib/srfi/%3a23.fasl
EXTRA_DIST += lib/srfi/%3a23.sls
CLEANFILES += lib/srfi/%3a23.fasl
endif

lib/srfi/%3a23/error.fasl: \
		lib/srfi/%3a23/error.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a23_error_fasldir = $(bundledlibsdir)/srfi/%3a23
nodist_lib_srfi__3a23_error_fasl_DATA = lib/srfi/%3a23/error.fasl
EXTRA_DIST += lib/srfi/%3a23/error.sls
CLEANFILES += lib/srfi/%3a23/error.fasl
endif

lib/srfi/%3a25.fasl: \
		lib/srfi/%3a25.sls \
		lib/srfi/%3a25/multi-dimensional-arrays.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a25_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a25_fasl_DATA = lib/srfi/%3a25.fasl
EXTRA_DIST += lib/srfi/%3a25.sls
CLEANFILES += lib/srfi/%3a25.fasl
endif

lib/srfi/%3a25/multi-dimensional-arrays.fasl: \
		lib/srfi/%3a25/multi-dimensional-arrays.sls \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/language-extensions/syntaxes.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a25_multi_dimensional_arrays_fasldir = $(bundledlibsdir)/srfi/%3a25
nodist_lib_srfi__3a25_multi_dimensional_arrays_fasl_DATA = lib/srfi/%3a25/multi-dimensional-arrays.fasl
EXTRA_DIST += lib/srfi/%3a25/multi-dimensional-arrays.sls
CLEANFILES += lib/srfi/%3a25/multi-dimensional-arrays.fasl
endif

lib/srfi/%3a26.fasl: \
		lib/srfi/%3a26.sls \
		lib/srfi/%3a26/cut.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a26_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a26_fasl_DATA = lib/srfi/%3a26.fasl
EXTRA_DIST += lib/srfi/%3a26.sls
CLEANFILES += lib/srfi/%3a26.fasl
endif

lib/srfi/%3a26/cut.fasl: \
		lib/srfi/%3a26/cut.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a26_cut_fasldir = $(bundledlibsdir)/srfi/%3a26
nodist_lib_srfi__3a26_cut_fasl_DATA = lib/srfi/%3a26/cut.fasl
EXTRA_DIST += lib/srfi/%3a26/cut.sls
CLEANFILES += lib/srfi/%3a26/cut.fasl
endif

lib/srfi/%3a27.fasl: \
		lib/srfi/%3a27.sls \
		lib/srfi/%3a27/random-bits.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a27_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a27_fasl_DATA = lib/srfi/%3a27.fasl
EXTRA_DIST += lib/srfi/%3a27.sls
CLEANFILES += lib/srfi/%3a27.fasl
endif

lib/srfi/%3a27/random-bits.fasl: \
		lib/srfi/%3a27/random-bits.sls \
		lib/srfi/%3a19/time.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a27_random_bits_fasldir = $(bundledlibsdir)/srfi/%3a27
nodist_lib_srfi__3a27_random_bits_fasl_DATA = lib/srfi/%3a27/random-bits.fasl
EXTRA_DIST += lib/srfi/%3a27/random-bits.sls
CLEANFILES += lib/srfi/%3a27/random-bits.fasl
endif

lib/srfi/%3a28.fasl: \
		lib/srfi/%3a28.sls \
		lib/srfi/%3a28/basic-format-strings.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a28_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a28_fasl_DATA = lib/srfi/%3a28.fasl
EXTRA_DIST += lib/srfi/%3a28.sls
CLEANFILES += lib/srfi/%3a28.fasl
endif

lib/srfi/%3a28/basic-format-strings.fasl: \
		lib/srfi/%3a28/basic-format-strings.sls \
		lib/srfi/%3a6.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a28_basic_format_strings_fasldir = $(bundledlibsdir)/srfi/%3a28
nodist_lib_srfi__3a28_basic_format_strings_fasl_DATA = lib/srfi/%3a28/basic-format-strings.fasl
EXTRA_DIST += lib/srfi/%3a28/basic-format-strings.sls
CLEANFILES += lib/srfi/%3a28/basic-format-strings.fasl
endif

lib/srfi/%3a31.fasl: \
		lib/srfi/%3a31.sls \
		lib/srfi/%3a31/rec.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a31_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a31_fasl_DATA = lib/srfi/%3a31.fasl
EXTRA_DIST += lib/srfi/%3a31.sls
CLEANFILES += lib/srfi/%3a31.fasl
endif

lib/srfi/%3a31/rec.fasl: \
		lib/srfi/%3a31/rec.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a31_rec_fasldir = $(bundledlibsdir)/srfi/%3a31
nodist_lib_srfi__3a31_rec_fasl_DATA = lib/srfi/%3a31/rec.fasl
EXTRA_DIST += lib/srfi/%3a31/rec.sls
CLEANFILES += lib/srfi/%3a31/rec.fasl
endif

lib/srfi/%3a37.fasl: \
		lib/srfi/%3a37.sls \
		lib/srfi/%3a37/args-fold.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a37_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a37_fasl_DATA = lib/srfi/%3a37.fasl
EXTRA_DIST += lib/srfi/%3a37.sls
CLEANFILES += lib/srfi/%3a37.fasl
endif

lib/srfi/%3a37/args-fold.fasl: \
		lib/srfi/%3a37/args-fold.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a37_args_fold_fasldir = $(bundledlibsdir)/srfi/%3a37
nodist_lib_srfi__3a37_args_fold_fasl_DATA = lib/srfi/%3a37/args-fold.fasl
EXTRA_DIST += lib/srfi/%3a37/args-fold.sls
CLEANFILES += lib/srfi/%3a37/args-fold.fasl
endif

lib/srfi/%3a38.fasl: \
		lib/srfi/%3a38.sls \
		lib/srfi/%3a38/with-shared-structure.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a38_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a38_fasl_DATA = lib/srfi/%3a38.fasl
EXTRA_DIST += lib/srfi/%3a38.sls
CLEANFILES += lib/srfi/%3a38.fasl
endif

lib/srfi/%3a38/with-shared-structure.fasl: \
		lib/srfi/%3a38/with-shared-structure.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a38_with_shared_structure_fasldir = $(bundledlibsdir)/srfi/%3a38
nodist_lib_srfi__3a38_with_shared_structure_fasl_DATA = lib/srfi/%3a38/with-shared-structure.fasl
EXTRA_DIST += lib/srfi/%3a38/with-shared-structure.sls
CLEANFILES += lib/srfi/%3a38/with-shared-structure.fasl
endif

lib/srfi/%3a39.fasl: \
		lib/srfi/%3a39.sls \
		lib/srfi/%3a39/parameters.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a39_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a39_fasl_DATA = lib/srfi/%3a39.fasl
EXTRA_DIST += lib/srfi/%3a39.sls
CLEANFILES += lib/srfi/%3a39.fasl
endif

lib/srfi/%3a39/parameters.fasl: \
		lib/srfi/%3a39/parameters.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a39_parameters_fasldir = $(bundledlibsdir)/srfi/%3a39
nodist_lib_srfi__3a39_parameters_fasl_DATA = lib/srfi/%3a39/parameters.fasl
EXTRA_DIST += lib/srfi/%3a39/parameters.sls
CLEANFILES += lib/srfi/%3a39/parameters.fasl
endif

lib/srfi/%3a41.fasl: \
		lib/srfi/%3a41.sls \
		lib/srfi/%3a41/streams.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a41_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a41_fasl_DATA = lib/srfi/%3a41.fasl
EXTRA_DIST += lib/srfi/%3a41.sls
CLEANFILES += lib/srfi/%3a41.fasl
endif

lib/srfi/%3a41/streams.fasl: \
		lib/srfi/%3a41/streams.sls \
		lib/srfi/%3a41/streams/primitive.fasl \
		lib/srfi/%3a41/streams/derived.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a41_streams_fasldir = $(bundledlibsdir)/srfi/%3a41
nodist_lib_srfi__3a41_streams_fasl_DATA = lib/srfi/%3a41/streams.fasl
EXTRA_DIST += lib/srfi/%3a41/streams.sls
CLEANFILES += lib/srfi/%3a41/streams.fasl
endif

lib/srfi/%3a41/streams/primitive.fasl: \
		lib/srfi/%3a41/streams/primitive.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a41_streams_primitive_fasldir = $(bundledlibsdir)/srfi/%3a41/streams
nodist_lib_srfi__3a41_streams_primitive_fasl_DATA = lib/srfi/%3a41/streams/primitive.fasl
EXTRA_DIST += lib/srfi/%3a41/streams/primitive.sls
CLEANFILES += lib/srfi/%3a41/streams/primitive.fasl
endif

lib/srfi/%3a41/streams/derived.fasl: \
		lib/srfi/%3a41/streams/derived.sls \
		lib/srfi/%3a41/streams/primitive.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a41_streams_derived_fasldir = $(bundledlibsdir)/srfi/%3a41/streams
nodist_lib_srfi__3a41_streams_derived_fasl_DATA = lib/srfi/%3a41/streams/derived.fasl
EXTRA_DIST += lib/srfi/%3a41/streams/derived.sls
CLEANFILES += lib/srfi/%3a41/streams/derived.fasl
endif

lib/srfi/%3a42.fasl: \
		lib/srfi/%3a42.sls \
		lib/srfi/%3a42/eager-comprehensions.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a42_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a42_fasl_DATA = lib/srfi/%3a42.fasl
EXTRA_DIST += lib/srfi/%3a42.sls
CLEANFILES += lib/srfi/%3a42.fasl
endif

lib/srfi/%3a42/eager-comprehensions.fasl: \
		lib/srfi/%3a42/eager-comprehensions.sls \
		lib/srfi/%3a39/parameters.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a42_eager_comprehensions_fasldir = $(bundledlibsdir)/srfi/%3a42
nodist_lib_srfi__3a42_eager_comprehensions_fasl_DATA = lib/srfi/%3a42/eager-comprehensions.fasl
EXTRA_DIST += lib/srfi/%3a42/eager-comprehensions.sls
CLEANFILES += lib/srfi/%3a42/eager-comprehensions.fasl
endif

lib/srfi/%3a43.fasl: \
		lib/srfi/%3a43.sls \
		lib/srfi/%3a43/vectors.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a43_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a43_fasl_DATA = lib/srfi/%3a43.fasl
EXTRA_DIST += lib/srfi/%3a43.sls
CLEANFILES += lib/srfi/%3a43.fasl
endif

lib/srfi/%3a43/vectors.fasl: \
		lib/srfi/%3a43/vectors.sls \
		lib/srfi/%3a8/receive.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a43_vectors_fasldir = $(bundledlibsdir)/srfi/%3a43
nodist_lib_srfi__3a43_vectors_fasl_DATA = lib/srfi/%3a43/vectors.fasl
EXTRA_DIST += lib/srfi/%3a43/vectors.sls
CLEANFILES += lib/srfi/%3a43/vectors.fasl
endif

lib/srfi/%3a45.fasl: \
		lib/srfi/%3a45.sls \
		lib/srfi/%3a45/lazy.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a45_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a45_fasl_DATA = lib/srfi/%3a45.fasl
EXTRA_DIST += lib/srfi/%3a45.sls
CLEANFILES += lib/srfi/%3a45.fasl
endif

lib/srfi/%3a45/lazy.fasl: \
		lib/srfi/%3a45/lazy.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a45_lazy_fasldir = $(bundledlibsdir)/srfi/%3a45
nodist_lib_srfi__3a45_lazy_fasl_DATA = lib/srfi/%3a45/lazy.fasl
EXTRA_DIST += lib/srfi/%3a45/lazy.sls
CLEANFILES += lib/srfi/%3a45/lazy.fasl
endif

lib/srfi/%3a48.fasl: \
		lib/srfi/%3a48.sls \
		lib/srfi/%3a48/intermediate-format-strings.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a48_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a48_fasl_DATA = lib/srfi/%3a48.fasl
EXTRA_DIST += lib/srfi/%3a48.sls
CLEANFILES += lib/srfi/%3a48.fasl
endif

lib/srfi/%3a48/intermediate-format-strings.fasl: \
		lib/srfi/%3a48/intermediate-format-strings.sls \
		lib/srfi/%3a6/basic-string-ports.fasl \
		lib/srfi/%3a38/with-shared-structure.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a48_intermediate_format_strings_fasldir = $(bundledlibsdir)/srfi/%3a48
nodist_lib_srfi__3a48_intermediate_format_strings_fasl_DATA = lib/srfi/%3a48/intermediate-format-strings.fasl
EXTRA_DIST += lib/srfi/%3a48/intermediate-format-strings.sls
CLEANFILES += lib/srfi/%3a48/intermediate-format-strings.fasl
endif

lib/srfi/%3a61.fasl: \
		lib/srfi/%3a61.sls \
		lib/srfi/%3a61/cond.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a61_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a61_fasl_DATA = lib/srfi/%3a61.fasl
EXTRA_DIST += lib/srfi/%3a61.sls
CLEANFILES += lib/srfi/%3a61.fasl
endif

lib/srfi/%3a61/cond.fasl: \
		lib/srfi/%3a61/cond.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a61_cond_fasldir = $(bundledlibsdir)/srfi/%3a61
nodist_lib_srfi__3a61_cond_fasl_DATA = lib/srfi/%3a61/cond.fasl
EXTRA_DIST += lib/srfi/%3a61/cond.sls
CLEANFILES += lib/srfi/%3a61/cond.fasl
endif

lib/srfi/%3a64.fasl: \
		lib/srfi/%3a64.sls \
		lib/srfi/%3a64/testing.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a64_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a64_fasl_DATA = lib/srfi/%3a64.fasl
EXTRA_DIST += lib/srfi/%3a64.sls
CLEANFILES += lib/srfi/%3a64.fasl
endif

lib/srfi/%3a64/testing.fasl: \
		lib/srfi/%3a64/testing.sls \
		lib/srfi/%3a0/cond-expand.fasl \
		lib/srfi/%3a1/lists.fasl \
		lib/srfi/%3a6/basic-string-ports.fasl \
		lib/srfi/%3a9/records.fasl \
		lib/srfi/%3a39/parameters.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a64_testing_fasldir = $(bundledlibsdir)/srfi/%3a64
nodist_lib_srfi__3a64_testing_fasl_DATA = lib/srfi/%3a64/testing.fasl
EXTRA_DIST += lib/srfi/%3a64/testing.sls
CLEANFILES += lib/srfi/%3a64/testing.fasl
endif

lib/srfi/%3a67.fasl: \
		lib/srfi/%3a67.sls \
		lib/srfi/%3a67/compare-procedures.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a67_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a67_fasl_DATA = lib/srfi/%3a67.fasl
EXTRA_DIST += lib/srfi/%3a67.sls
CLEANFILES += lib/srfi/%3a67.fasl
endif

lib/srfi/%3a67/compare-procedures.fasl: \
		lib/srfi/%3a67/compare-procedures.sls \
		lib/srfi/%3a27/random-bits.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a67_compare_procedures_fasldir = $(bundledlibsdir)/srfi/%3a67
nodist_lib_srfi__3a67_compare_procedures_fasl_DATA = lib/srfi/%3a67/compare-procedures.fasl
EXTRA_DIST += lib/srfi/%3a67/compare-procedures.sls
CLEANFILES += lib/srfi/%3a67/compare-procedures.fasl
endif

lib/srfi/%3a69.fasl: \
		lib/srfi/%3a69.sls \
		lib/srfi/%3a69/basic-hash-tables.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a69_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a69_fasl_DATA = lib/srfi/%3a69.fasl
EXTRA_DIST += lib/srfi/%3a69.sls
CLEANFILES += lib/srfi/%3a69.fasl
endif

lib/srfi/%3a69/basic-hash-tables.fasl: \
		lib/srfi/%3a69/basic-hash-tables.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a69_basic_hash_tables_fasldir = $(bundledlibsdir)/srfi/%3a69
nodist_lib_srfi__3a69_basic_hash_tables_fasl_DATA = lib/srfi/%3a69/basic-hash-tables.fasl
EXTRA_DIST += lib/srfi/%3a69/basic-hash-tables.sls
CLEANFILES += lib/srfi/%3a69/basic-hash-tables.fasl
endif

lib/srfi/%3a78.fasl: \
		lib/srfi/%3a78.sls \
		lib/srfi/%3a78/lightweight-testing.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a78_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a78_fasl_DATA = lib/srfi/%3a78.fasl
EXTRA_DIST += lib/srfi/%3a78.sls
CLEANFILES += lib/srfi/%3a78.fasl
endif

lib/srfi/%3a78/lightweight-testing.fasl: \
		lib/srfi/%3a78/lightweight-testing.sls \
		lib/srfi/%3a39/parameters.fasl \
		lib/srfi/%3a42/eager-comprehensions.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a78_lightweight_testing_fasldir = $(bundledlibsdir)/srfi/%3a78
nodist_lib_srfi__3a78_lightweight_testing_fasl_DATA = lib/srfi/%3a78/lightweight-testing.fasl
EXTRA_DIST += lib/srfi/%3a78/lightweight-testing.sls
CLEANFILES += lib/srfi/%3a78/lightweight-testing.fasl
endif

lib/srfi/%3a98.fasl: \
		lib/srfi/%3a98.sls \
		lib/srfi/%3a98/os-environment-variables.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a98_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a98_fasl_DATA = lib/srfi/%3a98.fasl
EXTRA_DIST += lib/srfi/%3a98.sls
CLEANFILES += lib/srfi/%3a98.fasl
endif

lib/srfi/%3a98/os-environment-variables.fasl: \
		lib/srfi/%3a98/os-environment-variables.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a98_os_environment_variables_fasldir = $(bundledlibsdir)/srfi/%3a98
nodist_lib_srfi__3a98_os_environment_variables_fasl_DATA = lib/srfi/%3a98/os-environment-variables.fasl
EXTRA_DIST += lib/srfi/%3a98/os-environment-variables.sls
CLEANFILES += lib/srfi/%3a98/os-environment-variables.fasl
endif

lib/srfi/%3a99.fasl: \
		lib/srfi/%3a99.sls \
		lib/srfi/%3a99/records.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a99_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a99_fasl_DATA = lib/srfi/%3a99.fasl
EXTRA_DIST += lib/srfi/%3a99.sls
CLEANFILES += lib/srfi/%3a99.fasl
endif

lib/srfi/%3a99/records.fasl: \
		lib/srfi/%3a99/records.sls \
		lib/srfi/%3a99/records/inspection.fasl \
		lib/srfi/%3a99/records/procedural.fasl \
		lib/srfi/%3a99/records/syntactic.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a99_records_fasldir = $(bundledlibsdir)/srfi/%3a99
nodist_lib_srfi__3a99_records_fasl_DATA = lib/srfi/%3a99/records.fasl
EXTRA_DIST += lib/srfi/%3a99/records.sls
CLEANFILES += lib/srfi/%3a99/records.fasl
endif

lib/srfi/%3a99/records/inspection.fasl: \
		lib/srfi/%3a99/records/inspection.sls \
		lib/srfi/%3a99/records/helper.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a99_records_inspection_fasldir = $(bundledlibsdir)/srfi/%3a99/records
nodist_lib_srfi__3a99_records_inspection_fasl_DATA = lib/srfi/%3a99/records/inspection.fasl
EXTRA_DIST += lib/srfi/%3a99/records/inspection.sls
CLEANFILES += lib/srfi/%3a99/records/inspection.fasl
endif

lib/srfi/%3a99/records/helper.fasl: \
		lib/srfi/%3a99/records/helper.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a99_records_helper_fasldir = $(bundledlibsdir)/srfi/%3a99/records
nodist_lib_srfi__3a99_records_helper_fasl_DATA = lib/srfi/%3a99/records/helper.fasl
EXTRA_DIST += lib/srfi/%3a99/records/helper.sls
CLEANFILES += lib/srfi/%3a99/records/helper.fasl
endif

lib/srfi/%3a99/records/procedural.fasl: \
		lib/srfi/%3a99/records/procedural.sls \
		lib/srfi/%3a99/records/inspection.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a99_records_procedural_fasldir = $(bundledlibsdir)/srfi/%3a99/records
nodist_lib_srfi__3a99_records_procedural_fasl_DATA = lib/srfi/%3a99/records/procedural.fasl
EXTRA_DIST += lib/srfi/%3a99/records/procedural.sls
CLEANFILES += lib/srfi/%3a99/records/procedural.fasl
endif

lib/srfi/%3a99/records/syntactic.fasl: \
		lib/srfi/%3a99/records/syntactic.sls \
		lib/srfi/%3a99/records/procedural.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a99_records_syntactic_fasldir = $(bundledlibsdir)/srfi/%3a99/records
nodist_lib_srfi__3a99_records_syntactic_fasl_DATA = lib/srfi/%3a99/records/syntactic.fasl
EXTRA_DIST += lib/srfi/%3a99/records/syntactic.sls
CLEANFILES += lib/srfi/%3a99/records/syntactic.fasl
endif

lib/srfi/%3a101.fasl: \
		lib/srfi/%3a101.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a101_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a101_fasl_DATA = lib/srfi/%3a101.fasl
EXTRA_DIST += lib/srfi/%3a101.sls
CLEANFILES += lib/srfi/%3a101.fasl
endif

lib/srfi/%3a101/random-access-lists.fasl: \
		lib/srfi/%3a101/random-access-lists.sls \
		lib/srfi/%3a101.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a101_random_access_lists_fasldir = $(bundledlibsdir)/srfi/%3a101
nodist_lib_srfi__3a101_random_access_lists_fasl_DATA = lib/srfi/%3a101/random-access-lists.fasl
EXTRA_DIST += lib/srfi/%3a101/random-access-lists.sls
CLEANFILES += lib/srfi/%3a101/random-access-lists.fasl
endif

lib/srfi/%3a101/random-access-lists/procedures.fasl: \
		lib/srfi/%3a101/random-access-lists/procedures.sls \
		lib/srfi/%3a101.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a101_random_access_lists_procedures_fasldir = $(bundledlibsdir)/srfi/%3a101/random-access-lists
nodist_lib_srfi__3a101_random_access_lists_procedures_fasl_DATA = lib/srfi/%3a101/random-access-lists/procedures.fasl
EXTRA_DIST += lib/srfi/%3a101/random-access-lists/procedures.sls
CLEANFILES += lib/srfi/%3a101/random-access-lists/procedures.fasl
endif

lib/srfi/%3a101/random-access-lists/syntax.fasl: \
		lib/srfi/%3a101/random-access-lists/syntax.sls \
		lib/srfi/%3a101.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a101_random_access_lists_syntax_fasldir = $(bundledlibsdir)/srfi/%3a101/random-access-lists
nodist_lib_srfi__3a101_random_access_lists_syntax_fasl_DATA = lib/srfi/%3a101/random-access-lists/syntax.fasl
EXTRA_DIST += lib/srfi/%3a101/random-access-lists/syntax.sls
CLEANFILES += lib/srfi/%3a101/random-access-lists/syntax.fasl
endif

lib/srfi/%3a101/random-access-lists/equal.fasl: \
		lib/srfi/%3a101/random-access-lists/equal.sls \
		lib/srfi/%3a101.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a101_random_access_lists_equal_fasldir = $(bundledlibsdir)/srfi/%3a101/random-access-lists
nodist_lib_srfi__3a101_random_access_lists_equal_fasl_DATA = lib/srfi/%3a101/random-access-lists/equal.fasl
EXTRA_DIST += lib/srfi/%3a101/random-access-lists/equal.sls
CLEANFILES += lib/srfi/%3a101/random-access-lists/equal.fasl
endif

lib/srfi/%3a111.fasl: \
		lib/srfi/%3a111.sls \
		lib/srfi/%3a111/boxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a111_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a111_fasl_DATA = lib/srfi/%3a111.fasl
EXTRA_DIST += lib/srfi/%3a111.sls
CLEANFILES += lib/srfi/%3a111.fasl
endif

lib/srfi/%3a111/boxes.fasl: \
		lib/srfi/%3a111/boxes.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a111_boxes_fasldir = $(bundledlibsdir)/srfi/%3a111
nodist_lib_srfi__3a111_boxes_fasl_DATA = lib/srfi/%3a111/boxes.fasl
EXTRA_DIST += lib/srfi/%3a111/boxes.sls
CLEANFILES += lib/srfi/%3a111/boxes.fasl
endif

lib/srfi/%3a112.fasl: \
		lib/srfi/%3a112.sls \
		lib/srfi/%3a112/environment-inquiry.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a112_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a112_fasl_DATA = lib/srfi/%3a112.fasl
EXTRA_DIST += lib/srfi/%3a112.sls
CLEANFILES += lib/srfi/%3a112.fasl
endif

lib/srfi/%3a112/environment-inquiry.fasl: \
		lib/srfi/%3a112/environment-inquiry.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
lib_srfi__3a112_environment_inquiry_fasldir = $(bundledlibsdir)/srfi/%3a112
nodist_lib_srfi__3a112_environment_inquiry_fasl_DATA = lib/srfi/%3a112/environment-inquiry.fasl
EXTRA_DIST += lib/srfi/%3a112/environment-inquiry.sls
CLEANFILES += lib/srfi/%3a112/environment-inquiry.fasl
endif

lib/srfi/%3a106.fasl: \
		lib/srfi/%3a106.sls \
		lib/srfi/%3a106/socket.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
if WANT_POSIX
lib_srfi__3a106_fasldir = $(bundledlibsdir)/srfi
nodist_lib_srfi__3a106_fasl_DATA = lib/srfi/%3a106.fasl
EXTRA_DIST += lib/srfi/%3a106.sls
CLEANFILES += lib/srfi/%3a106.fasl
endif
endif

lib/srfi/%3a106/socket.fasl: \
		lib/srfi/%3a106/socket.sls \
		lib/srfi/%3a106/compat.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
if WANT_POSIX
lib_srfi__3a106_socket_fasldir = $(bundledlibsdir)/srfi/%3a106
nodist_lib_srfi__3a106_socket_fasl_DATA = lib/srfi/%3a106/socket.fasl
EXTRA_DIST += lib/srfi/%3a106/socket.sls
CLEANFILES += lib/srfi/%3a106/socket.fasl
endif
endif

lib/srfi/%3a106/compat.fasl: \
		lib/srfi/%3a106/compat.vicare.sls \
		lib/vicare/platform/constants.fasl \
		lib/vicare/posix.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_SRFI
if WANT_POSIX
lib_srfi__3a106_compat_fasldir = $(bundledlibsdir)/srfi/%3a106
nodist_lib_srfi__3a106_compat_fasl_DATA = lib/srfi/%3a106/compat.fasl
EXTRA_DIST += lib/srfi/%3a106/compat.vicare.sls
CLEANFILES += lib/srfi/%3a106/compat.fasl
endif
endif

lib/nausicaa/language/auxiliary-syntaxes.fasl: \
		lib/nausicaa/language/auxiliary-syntaxes.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_auxiliary_syntaxes_fasldir = $(bundledlibsdir)/nausicaa/language
nodist_lib_nausicaa_language_auxiliary_syntaxes_fasl_DATA = lib/nausicaa/language/auxiliary-syntaxes.fasl
EXTRA_DIST += lib/nausicaa/language/auxiliary-syntaxes.sls
CLEANFILES += lib/nausicaa/language/auxiliary-syntaxes.fasl
endif

lib/nausicaa/language/oopp.fasl: \
		lib/nausicaa/language/oopp.sls \
		lib/nausicaa/language/oopp/auxiliary-syntaxes.fasl \
		lib/nausicaa/language/oopp/conditions.fasl \
		lib/nausicaa/language/oopp/oopp-syntax-helpers.fasl \
		lib/nausicaa/language/oopp/definition-parser-helpers.fasl \
		lib/nausicaa/language/oopp/configuration.fasl \
		lib/nausicaa/language/auxiliary-syntaxes.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_oopp_fasldir = $(bundledlibsdir)/nausicaa/language
nodist_lib_nausicaa_language_oopp_fasl_DATA = lib/nausicaa/language/oopp.fasl
EXTRA_DIST += lib/nausicaa/language/oopp.sls
CLEANFILES += lib/nausicaa/language/oopp.fasl
endif

lib/nausicaa/language/oopp/auxiliary-syntaxes.fasl: \
		lib/nausicaa/language/oopp/auxiliary-syntaxes.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_oopp_auxiliary_syntaxes_fasldir = $(bundledlibsdir)/nausicaa/language/oopp
nodist_lib_nausicaa_language_oopp_auxiliary_syntaxes_fasl_DATA = lib/nausicaa/language/oopp/auxiliary-syntaxes.fasl
EXTRA_DIST += lib/nausicaa/language/oopp/auxiliary-syntaxes.sls
CLEANFILES += lib/nausicaa/language/oopp/auxiliary-syntaxes.fasl
endif

lib/nausicaa/language/oopp/conditions.fasl: \
		lib/nausicaa/language/oopp/conditions.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_oopp_conditions_fasldir = $(bundledlibsdir)/nausicaa/language/oopp
nodist_lib_nausicaa_language_oopp_conditions_fasl_DATA = lib/nausicaa/language/oopp/conditions.fasl
EXTRA_DIST += lib/nausicaa/language/oopp/conditions.sls
CLEANFILES += lib/nausicaa/language/oopp/conditions.fasl
endif

lib/nausicaa/language/oopp/oopp-syntax-helpers.fasl: \
		lib/nausicaa/language/oopp/oopp-syntax-helpers.sls \
		lib/nausicaa/language/oopp/configuration.fasl \
		lib/nausicaa/language/oopp/auxiliary-syntaxes.fasl \
		lib/nausicaa/language/auxiliary-syntaxes.fasl \
		lib/nausicaa/language/oopp/conditions.fasl \
		lib/vicare/language-extensions/identifier-substitutions.fasl \
		lib/nausicaa/language/oopp/definition-parser-helpers.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_oopp_oopp_syntax_helpers_fasldir = $(bundledlibsdir)/nausicaa/language/oopp
nodist_lib_nausicaa_language_oopp_oopp_syntax_helpers_fasl_DATA = lib/nausicaa/language/oopp/oopp-syntax-helpers.fasl
EXTRA_DIST += lib/nausicaa/language/oopp/oopp-syntax-helpers.sls
CLEANFILES += lib/nausicaa/language/oopp/oopp-syntax-helpers.fasl
endif

lib/nausicaa/language/oopp/configuration.fasl: \
		lib/nausicaa/language/oopp/configuration.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_oopp_configuration_fasldir = $(bundledlibsdir)/nausicaa/language/oopp
nodist_lib_nausicaa_language_oopp_configuration_fasl_DATA = lib/nausicaa/language/oopp/configuration.fasl
EXTRA_DIST += lib/nausicaa/language/oopp/configuration.sls
CLEANFILES += lib/nausicaa/language/oopp/configuration.fasl
endif

lib/nausicaa/language/oopp/definition-parser-helpers.fasl: \
		lib/nausicaa/language/oopp/definition-parser-helpers.sls \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/language-extensions/identifier-substitutions.fasl \
		lib/nausicaa/language/oopp/configuration.fasl \
		lib/nausicaa/language/oopp/auxiliary-syntaxes.fasl \
		lib/nausicaa/language/auxiliary-syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_oopp_definition_parser_helpers_fasldir = $(bundledlibsdir)/nausicaa/language/oopp
nodist_lib_nausicaa_language_oopp_definition_parser_helpers_fasl_DATA = lib/nausicaa/language/oopp/definition-parser-helpers.fasl
EXTRA_DIST += lib/nausicaa/language/oopp/definition-parser-helpers.sls
CLEANFILES += lib/nausicaa/language/oopp/definition-parser-helpers.fasl
endif

lib/nausicaa/language/multimethods.fasl: \
		lib/nausicaa/language/multimethods.sls \
		lib/nausicaa/language/multimethods/types.fasl \
		lib/nausicaa/language/multimethods/methods-table.fasl \
		lib/nausicaa/language/auxiliary-syntaxes.fasl \
		lib/nausicaa/language/multimethods/auxiliary-syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_multimethods_fasldir = $(bundledlibsdir)/nausicaa/language
nodist_lib_nausicaa_language_multimethods_fasl_DATA = lib/nausicaa/language/multimethods.fasl
EXTRA_DIST += lib/nausicaa/language/multimethods.sls
CLEANFILES += lib/nausicaa/language/multimethods.fasl
endif

lib/nausicaa/language/multimethods/types.fasl: \
		lib/nausicaa/language/multimethods/types.sls \
		lib/nausicaa/language/oopp.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_multimethods_types_fasldir = $(bundledlibsdir)/nausicaa/language/multimethods
nodist_lib_nausicaa_language_multimethods_types_fasl_DATA = lib/nausicaa/language/multimethods/types.fasl
EXTRA_DIST += lib/nausicaa/language/multimethods/types.sls
CLEANFILES += lib/nausicaa/language/multimethods/types.fasl
endif

lib/nausicaa/language/multimethods/methods-table.fasl: \
		lib/nausicaa/language/multimethods/methods-table.sls \
		lib/nausicaa/language/symbols-tree.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_multimethods_methods_table_fasldir = $(bundledlibsdir)/nausicaa/language/multimethods
nodist_lib_nausicaa_language_multimethods_methods_table_fasl_DATA = lib/nausicaa/language/multimethods/methods-table.fasl
EXTRA_DIST += lib/nausicaa/language/multimethods/methods-table.sls
CLEANFILES += lib/nausicaa/language/multimethods/methods-table.fasl
endif

lib/nausicaa/language/symbols-tree.fasl: \
		lib/nausicaa/language/symbols-tree.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_symbols_tree_fasldir = $(bundledlibsdir)/nausicaa/language
nodist_lib_nausicaa_language_symbols_tree_fasl_DATA = lib/nausicaa/language/symbols-tree.fasl
EXTRA_DIST += lib/nausicaa/language/symbols-tree.sls
CLEANFILES += lib/nausicaa/language/symbols-tree.fasl
endif

lib/nausicaa/language/multimethods/auxiliary-syntaxes.fasl: \
		lib/nausicaa/language/multimethods/auxiliary-syntaxes.sls \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_multimethods_auxiliary_syntaxes_fasldir = $(bundledlibsdir)/nausicaa/language/multimethods
nodist_lib_nausicaa_language_multimethods_auxiliary_syntaxes_fasl_DATA = lib/nausicaa/language/multimethods/auxiliary-syntaxes.fasl
EXTRA_DIST += lib/nausicaa/language/multimethods/auxiliary-syntaxes.sls
CLEANFILES += lib/nausicaa/language/multimethods/auxiliary-syntaxes.fasl
endif

lib/nausicaa/language/builtins.fasl: \
		lib/nausicaa/language/builtins.sls \
		lib/vicare/language-extensions/sentinels.fasl \
		lib/nausicaa/language/oopp.fasl \
		lib/nausicaa/language/multimethods.fasl \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/containers/bytevectors.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_builtins_fasldir = $(bundledlibsdir)/nausicaa/language
nodist_lib_nausicaa_language_builtins_fasl_DATA = lib/nausicaa/language/builtins.fasl
EXTRA_DIST += lib/nausicaa/language/builtins.sls
CLEANFILES += lib/nausicaa/language/builtins.fasl
endif

lib/nausicaa/language/conditions.fasl: \
		lib/nausicaa/language/conditions.sls \
		lib/nausicaa/language/oopp.fasl \
		lib/nausicaa/language/builtins.fasl \
		lib/nausicaa/language/auxiliary-syntaxes.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_conditions_fasldir = $(bundledlibsdir)/nausicaa/language
nodist_lib_nausicaa_language_conditions_fasl_DATA = lib/nausicaa/language/conditions.fasl
EXTRA_DIST += lib/nausicaa/language/conditions.sls
CLEANFILES += lib/nausicaa/language/conditions.fasl
endif

lib/nausicaa/language/simple-match.fasl: \
		lib/nausicaa/language/simple-match.sls \
		lib/nausicaa/language/oopp.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_simple_match_fasldir = $(bundledlibsdir)/nausicaa/language
nodist_lib_nausicaa_language_simple_match_fasl_DATA = lib/nausicaa/language/simple-match.fasl
EXTRA_DIST += lib/nausicaa/language/simple-match.sls
CLEANFILES += lib/nausicaa/language/simple-match.fasl
endif

lib/nausicaa/language/infix.fasl: \
		lib/nausicaa/language/infix.sls \
		lib/vicare/language-extensions/infix.fasl \
		lib/vicare/language-extensions/infix/parser-utils.fasl \
		lib/vicare/language-extensions/infix/tokens.fasl \
		lib/nausicaa/language/increments.fasl \
		lib/nausicaa/language/oopp.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_infix_fasldir = $(bundledlibsdir)/nausicaa/language
nodist_lib_nausicaa_language_infix_fasl_DATA = lib/nausicaa/language/infix.fasl
EXTRA_DIST += lib/nausicaa/language/infix.sls
CLEANFILES += lib/nausicaa/language/infix.fasl
endif

lib/nausicaa/language/increments.fasl: \
		lib/nausicaa/language/increments.sls \
		lib/nausicaa/language/oopp.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_language_increments_fasldir = $(bundledlibsdir)/nausicaa/language
nodist_lib_nausicaa_language_increments_fasl_DATA = lib/nausicaa/language/increments.fasl
EXTRA_DIST += lib/nausicaa/language/increments.sls
CLEANFILES += lib/nausicaa/language/increments.fasl
endif

lib/nausicaa.fasl: \
		lib/nausicaa.sls \
		lib/nausicaa/language/oopp.fasl \
		lib/nausicaa/language/multimethods.fasl \
		lib/nausicaa/language/builtins.fasl \
		lib/nausicaa/language/conditions.fasl \
		lib/nausicaa/language/increments.fasl \
		lib/nausicaa/language/simple-match.fasl \
		lib/nausicaa/language/infix.fasl \
		lib/vicare/language-extensions/namespaces.fasl \
		lib/vicare/language-extensions/sentinels.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_fasldir = $(bundledlibsdir)/
nodist_lib_nausicaa_fasl_DATA = lib/nausicaa.fasl
EXTRA_DIST += lib/nausicaa.sls
CLEANFILES += lib/nausicaa.fasl
endif

lib/nausicaa/containers/lists.fasl: \
		lib/nausicaa/containers/lists.sls \
		lib/nausicaa.fasl \
		lib/vicare/containers/lists.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_containers_lists_fasldir = $(bundledlibsdir)/nausicaa/containers
nodist_lib_nausicaa_containers_lists_fasl_DATA = lib/nausicaa/containers/lists.fasl
EXTRA_DIST += lib/nausicaa/containers/lists.sls
CLEANFILES += lib/nausicaa/containers/lists.fasl
endif

lib/nausicaa/containers/vectors.fasl: \
		lib/nausicaa/containers/vectors.sls \
		lib/nausicaa.fasl \
		lib/vicare/containers/vectors.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_containers_vectors_fasldir = $(bundledlibsdir)/nausicaa/containers
nodist_lib_nausicaa_containers_vectors_fasl_DATA = lib/nausicaa/containers/vectors.fasl
EXTRA_DIST += lib/nausicaa/containers/vectors.sls
CLEANFILES += lib/nausicaa/containers/vectors.fasl
endif

lib/nausicaa/containers/strings.fasl: \
		lib/nausicaa/containers/strings.sls \
		lib/nausicaa.fasl \
		lib/vicare/containers/strings.fasl \
		lib/vicare/containers/strings/low.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_containers_strings_fasldir = $(bundledlibsdir)/nausicaa/containers
nodist_lib_nausicaa_containers_strings_fasl_DATA = lib/nausicaa/containers/strings.fasl
EXTRA_DIST += lib/nausicaa/containers/strings.sls
CLEANFILES += lib/nausicaa/containers/strings.fasl
endif

lib/nausicaa/containers/arrays.fasl: \
		lib/nausicaa/containers/arrays.sls \
		lib/nausicaa.fasl \
		lib/vicare/containers/strings.fasl \
		lib/vicare/containers/lists.fasl \
		lib/vicare/containers/vectors.fasl \
		lib/nausicaa/containers/lists.fasl \
		lib/nausicaa/containers/vectors.fasl \
		lib/nausicaa/containers/strings.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_containers_arrays_fasldir = $(bundledlibsdir)/nausicaa/containers
nodist_lib_nausicaa_containers_arrays_fasl_DATA = lib/nausicaa/containers/arrays.fasl
EXTRA_DIST += lib/nausicaa/containers/arrays.sls
CLEANFILES += lib/nausicaa/containers/arrays.fasl
endif

lib/nausicaa/containers/stacks.fasl: \
		lib/nausicaa/containers/stacks.sls \
		lib/nausicaa.fasl \
		lib/vicare/containers/stacks.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_containers_stacks_fasldir = $(bundledlibsdir)/nausicaa/containers
nodist_lib_nausicaa_containers_stacks_fasl_DATA = lib/nausicaa/containers/stacks.fasl
EXTRA_DIST += lib/nausicaa/containers/stacks.sls
CLEANFILES += lib/nausicaa/containers/stacks.fasl
endif

lib/nausicaa/containers/queues.fasl: \
		lib/nausicaa/containers/queues.sls \
		lib/nausicaa.fasl \
		lib/vicare/containers/queues.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_containers_queues_fasldir = $(bundledlibsdir)/nausicaa/containers
nodist_lib_nausicaa_containers_queues_fasl_DATA = lib/nausicaa/containers/queues.fasl
EXTRA_DIST += lib/nausicaa/containers/queues.sls
CLEANFILES += lib/nausicaa/containers/queues.fasl
endif

lib/nausicaa/containers/bitvectors.fasl: \
		lib/nausicaa/containers/bitvectors.sls \
		lib/nausicaa.fasl \
		lib/vicare/platform/words.fasl \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_containers_bitvectors_fasldir = $(bundledlibsdir)/nausicaa/containers
nodist_lib_nausicaa_containers_bitvectors_fasl_DATA = lib/nausicaa/containers/bitvectors.fasl
EXTRA_DIST += lib/nausicaa/containers/bitvectors.sls
CLEANFILES += lib/nausicaa/containers/bitvectors.fasl
endif

lib/nausicaa/containers/iterators.fasl: \
		lib/nausicaa/containers/iterators.sls \
		lib/nausicaa.fasl \
		lib/vicare/language-extensions/makers.fasl \
		lib/vicare/arguments/validation.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_containers_iterators_fasldir = $(bundledlibsdir)/nausicaa/containers
nodist_lib_nausicaa_containers_iterators_fasl_DATA = lib/nausicaa/containers/iterators.fasl
EXTRA_DIST += lib/nausicaa/containers/iterators.sls
CLEANFILES += lib/nausicaa/containers/iterators.fasl
endif

lib/nausicaa/parser-tools/source-locations.fasl: \
		lib/nausicaa/parser-tools/source-locations.sls \
		lib/nausicaa.fasl \
		lib/vicare/language-extensions/makers.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_source_locations_fasldir = $(bundledlibsdir)/nausicaa/parser-tools
nodist_lib_nausicaa_parser_tools_source_locations_fasl_DATA = lib/nausicaa/parser-tools/source-locations.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/source-locations.sls
CLEANFILES += lib/nausicaa/parser-tools/source-locations.fasl
endif

lib/nausicaa/parser-tools/lexical-tokens.fasl: \
		lib/nausicaa/parser-tools/lexical-tokens.sls \
		lib/nausicaa.fasl \
		lib/nausicaa/parser-tools/source-locations.fasl \
		lib/vicare/language-extensions/makers.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_lexical_tokens_fasldir = $(bundledlibsdir)/nausicaa/parser-tools
nodist_lib_nausicaa_parser_tools_lexical_tokens_fasl_DATA = lib/nausicaa/parser-tools/lexical-tokens.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/lexical-tokens.sls
CLEANFILES += lib/nausicaa/parser-tools/lexical-tokens.fasl
endif

lib/nausicaa/parser-tools/silex/default-error-handler.fasl: \
		lib/nausicaa/parser-tools/silex/default-error-handler.sls \
		lib/nausicaa.fasl \
		lib/nausicaa/parser-tools/source-locations.fasl \
		lib/nausicaa/parser-tools/lexical-tokens.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_silex_default_error_handler_fasldir = $(bundledlibsdir)/nausicaa/parser-tools/silex
nodist_lib_nausicaa_parser_tools_silex_default_error_handler_fasl_DATA = lib/nausicaa/parser-tools/silex/default-error-handler.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/silex/default-error-handler.sls
CLEANFILES += lib/nausicaa/parser-tools/silex/default-error-handler.fasl
endif

lib/nausicaa/parser-tools/lalr/lr-driver.fasl: \
		lib/nausicaa/parser-tools/lalr/lr-driver.sls \
		lib/nausicaa.fasl \
		lib/nausicaa/parser-tools/lexical-tokens.fasl \
		lib/nausicaa/parser-tools/source-locations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_lalr_lr_driver_fasldir = $(bundledlibsdir)/nausicaa/parser-tools/lalr
nodist_lib_nausicaa_parser_tools_lalr_lr_driver_fasl_DATA = lib/nausicaa/parser-tools/lalr/lr-driver.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/lalr/lr-driver.sls
CLEANFILES += lib/nausicaa/parser-tools/lalr/lr-driver.fasl
endif

lib/nausicaa/parser-tools/lalr/glr-driver.fasl: \
		lib/nausicaa/parser-tools/lalr/glr-driver.sls \
		lib/nausicaa.fasl \
		lib/nausicaa/parser-tools/lexical-tokens.fasl \
		lib/nausicaa/parser-tools/source-locations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_lalr_glr_driver_fasldir = $(bundledlibsdir)/nausicaa/parser-tools/lalr
nodist_lib_nausicaa_parser_tools_lalr_glr_driver_fasl_DATA = lib/nausicaa/parser-tools/lalr/glr-driver.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/lalr/glr-driver.sls
CLEANFILES += lib/nausicaa/parser-tools/lalr/glr-driver.fasl
endif

lib/nausicaa/parser-tools/lalr.fasl: \
		lib/nausicaa/parser-tools/lalr.sls \
		lib/nausicaa.fasl \
		lib/nausicaa/parser-tools/lexical-tokens.fasl \
		lib/nausicaa/parser-tools/source-locations.fasl \
		lib/vicare/language-extensions/makers.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_lalr_fasldir = $(bundledlibsdir)/nausicaa/parser-tools
nodist_lib_nausicaa_parser_tools_lalr_fasl_DATA = lib/nausicaa/parser-tools/lalr.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/lalr.sls
CLEANFILES += lib/nausicaa/parser-tools/lalr.fasl
endif

lib/nausicaa/parser-tools/ip-addresses/ipv4-address-lexer.fasl: \
		lib/nausicaa/parser-tools/ip-addresses/ipv4-address-lexer.sls \
		lib/nausicaa.fasl \
		lib/vicare/parser-tools/silex/input-system.fasl \
		lib/nausicaa/parser-tools/silex/default-error-handler.fasl \
		lib/nausicaa/parser-tools/lexical-tokens.fasl \
		lib/nausicaa/parser-tools/source-locations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_ip_addresses_ipv4_address_lexer_fasldir = $(bundledlibsdir)/nausicaa/parser-tools/ip-addresses
nodist_lib_nausicaa_parser_tools_ip_addresses_ipv4_address_lexer_fasl_DATA = lib/nausicaa/parser-tools/ip-addresses/ipv4-address-lexer.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/ip-addresses/ipv4-address-lexer.sls
CLEANFILES += lib/nausicaa/parser-tools/ip-addresses/ipv4-address-lexer.fasl
endif

lib/nausicaa/parser-tools/ip-addresses/ipv4-address-parser.fasl: \
		lib/nausicaa/parser-tools/ip-addresses/ipv4-address-parser.sls \
		lib/nausicaa.fasl \
		lib/nausicaa/parser-tools/lalr/lr-driver.fasl \
		lib/nausicaa/parser-tools/lexical-tokens.fasl \
		lib/nausicaa/parser-tools/source-locations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_ip_addresses_ipv4_address_parser_fasldir = $(bundledlibsdir)/nausicaa/parser-tools/ip-addresses
nodist_lib_nausicaa_parser_tools_ip_addresses_ipv4_address_parser_fasl_DATA = lib/nausicaa/parser-tools/ip-addresses/ipv4-address-parser.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/ip-addresses/ipv4-address-parser.sls
CLEANFILES += lib/nausicaa/parser-tools/ip-addresses/ipv4-address-parser.fasl
endif

lib/nausicaa/parser-tools/ip-addresses/ipv6-address-lexer.fasl: \
		lib/nausicaa/parser-tools/ip-addresses/ipv6-address-lexer.sls \
		lib/nausicaa.fasl \
		lib/vicare/parser-tools/silex/input-system.fasl \
		lib/nausicaa/parser-tools/silex/default-error-handler.fasl \
		lib/nausicaa/parser-tools/lexical-tokens.fasl \
		lib/nausicaa/parser-tools/source-locations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_ip_addresses_ipv6_address_lexer_fasldir = $(bundledlibsdir)/nausicaa/parser-tools/ip-addresses
nodist_lib_nausicaa_parser_tools_ip_addresses_ipv6_address_lexer_fasl_DATA = lib/nausicaa/parser-tools/ip-addresses/ipv6-address-lexer.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/ip-addresses/ipv6-address-lexer.sls
CLEANFILES += lib/nausicaa/parser-tools/ip-addresses/ipv6-address-lexer.fasl
endif

lib/nausicaa/parser-tools/ip-addresses/ipv6-address-parser.fasl: \
		lib/nausicaa/parser-tools/ip-addresses/ipv6-address-parser.sls \
		lib/nausicaa.fasl \
		lib/nausicaa/parser-tools/lalr/lr-driver.fasl \
		lib/nausicaa/parser-tools/lexical-tokens.fasl \
		lib/nausicaa/parser-tools/source-locations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_ip_addresses_ipv6_address_parser_fasldir = $(bundledlibsdir)/nausicaa/parser-tools/ip-addresses
nodist_lib_nausicaa_parser_tools_ip_addresses_ipv6_address_parser_fasl_DATA = lib/nausicaa/parser-tools/ip-addresses/ipv6-address-parser.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/ip-addresses/ipv6-address-parser.sls
CLEANFILES += lib/nausicaa/parser-tools/ip-addresses/ipv6-address-parser.fasl
endif

lib/nausicaa/parser-tools/ipv4-addresses.fasl: \
		lib/nausicaa/parser-tools/ipv4-addresses.sls \
		lib/nausicaa.fasl \
		lib/nausicaa/parser-tools/ip-addresses/ipv4-address-lexer.fasl \
		lib/nausicaa/parser-tools/ip-addresses/ipv4-address-parser.fasl \
		lib/vicare/language-extensions/makers.fasl \
		lib/vicare/parser-tools/silex/lexer.fasl \
		lib/nausicaa/parser-tools/lexical-tokens.fasl \
		lib/nausicaa/parser-tools/source-locations.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_ipv4_addresses_fasldir = $(bundledlibsdir)/nausicaa/parser-tools
nodist_lib_nausicaa_parser_tools_ipv4_addresses_fasl_DATA = lib/nausicaa/parser-tools/ipv4-addresses.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/ipv4-addresses.sls
CLEANFILES += lib/nausicaa/parser-tools/ipv4-addresses.fasl
endif

lib/nausicaa/parser-tools/ipv6-addresses.fasl: \
		lib/nausicaa/parser-tools/ipv6-addresses.sls \
		lib/nausicaa.fasl \
		lib/nausicaa/parser-tools/ip-addresses/ipv6-address-lexer.fasl \
		lib/nausicaa/parser-tools/ip-addresses/ipv6-address-parser.fasl \
		lib/vicare/language-extensions/makers.fasl \
		lib/vicare/parser-tools/silex/lexer.fasl \
		lib/nausicaa/parser-tools/lexical-tokens.fasl \
		lib/nausicaa/parser-tools/source-locations.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_ipv6_addresses_fasldir = $(bundledlibsdir)/nausicaa/parser-tools
nodist_lib_nausicaa_parser_tools_ipv6_addresses_fasl_DATA = lib/nausicaa/parser-tools/ipv6-addresses.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/ipv6-addresses.sls
CLEANFILES += lib/nausicaa/parser-tools/ipv6-addresses.fasl
endif

lib/nausicaa/parser-tools/uri.fasl: \
		lib/nausicaa/parser-tools/uri.sls \
		lib/nausicaa.fasl \
		lib/nausicaa/parser-tools/ipv4-addresses.fasl \
		lib/nausicaa/parser-tools/ipv6-addresses.fasl \
		lib/vicare/language-extensions/makers.fasl \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/language-extensions/ascii-chars.fasl \
		lib/vicare/arguments/validation.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_uri_fasldir = $(bundledlibsdir)/nausicaa/parser-tools
nodist_lib_nausicaa_parser_tools_uri_fasl_DATA = lib/nausicaa/parser-tools/uri.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/uri.sls
CLEANFILES += lib/nausicaa/parser-tools/uri.fasl
endif

lib/nausicaa/uri/ip.fasl: \
		lib/nausicaa/uri/ip.sls \
		lib/nausicaa.fasl \
		lib/vicare/language-extensions/keywords.fasl \
		lib/vicare/language-extensions/ascii-chars.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_uri_ip_fasldir = $(bundledlibsdir)/nausicaa/uri
nodist_lib_nausicaa_uri_ip_fasl_DATA = lib/nausicaa/uri/ip.fasl
EXTRA_DIST += lib/nausicaa/uri/ip.sls
CLEANFILES += lib/nausicaa/uri/ip.fasl
endif

lib/nausicaa/uri.fasl: \
		lib/nausicaa/uri.sls \
		lib/nausicaa.fasl \
		lib/vicare/language-extensions/makers.fasl \
		lib/vicare/unsafe/operations.fasl \
		lib/vicare/language-extensions/ascii-chars.fasl \
		lib/nausicaa/uri/ip.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_uri_fasldir = $(bundledlibsdir)/nausicaa
nodist_lib_nausicaa_uri_fasl_DATA = lib/nausicaa/uri.fasl
EXTRA_DIST += lib/nausicaa/uri.sls
CLEANFILES += lib/nausicaa/uri.fasl
endif

lib/nausicaa/parser-tools/uri/utilities.fasl: \
		lib/nausicaa/parser-tools/uri/utilities.sls \
		lib/nausicaa.fasl \
		lib/nausicaa/parser-tools/uri.fasl \
		lib/nausicaa/uri.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_parser_tools_uri_utilities_fasldir = $(bundledlibsdir)/nausicaa/parser-tools/uri
nodist_lib_nausicaa_parser_tools_uri_utilities_fasl_DATA = lib/nausicaa/parser-tools/uri/utilities.fasl
EXTRA_DIST += lib/nausicaa/parser-tools/uri/utilities.sls
CLEANFILES += lib/nausicaa/parser-tools/uri/utilities.fasl
endif

lib/nausicaa/uri/pathnames/abstract.fasl: \
		lib/nausicaa/uri/pathnames/abstract.sls \
		lib/nausicaa.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_uri_pathnames_abstract_fasldir = $(bundledlibsdir)/nausicaa/uri/pathnames
nodist_lib_nausicaa_uri_pathnames_abstract_fasl_DATA = lib/nausicaa/uri/pathnames/abstract.fasl
EXTRA_DIST += lib/nausicaa/uri/pathnames/abstract.sls
CLEANFILES += lib/nausicaa/uri/pathnames/abstract.fasl
endif

lib/nausicaa/uri/pathnames/unix.fasl: \
		lib/nausicaa/uri/pathnames/unix.sls \
		lib/nausicaa.fasl \
		lib/vicare/unsafe/operations.fasl \
		lib/nausicaa/uri/pathnames/abstract.fasl \
		lib/vicare/parser-tools/unix-pathnames.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_uri_pathnames_unix_fasldir = $(bundledlibsdir)/nausicaa/uri/pathnames
nodist_lib_nausicaa_uri_pathnames_unix_fasl_DATA = lib/nausicaa/uri/pathnames/unix.fasl
EXTRA_DIST += lib/nausicaa/uri/pathnames/unix.sls
CLEANFILES += lib/nausicaa/uri/pathnames/unix.fasl
endif

lib/nausicaa/uri/pathnames.fasl: \
		lib/nausicaa/uri/pathnames.sls \
		lib/nausicaa/uri/pathnames/unix.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_uri_pathnames_fasldir = $(bundledlibsdir)/nausicaa/uri
nodist_lib_nausicaa_uri_pathnames_fasl_DATA = lib/nausicaa/uri/pathnames.fasl
CLEANFILES += lib/nausicaa/uri/pathnames.fasl
endif

lib/nausicaa/mehve.fasl: \
		lib/nausicaa/mehve.sls \
		lib/nausicaa.fasl \
		lib/nausicaa/mehve/language/numerics/predicates.fasl \
		lib/nausicaa/mehve/language/numerics/arithmetics.fasl \
		lib/nausicaa/mehve/language/numerics/parts.fasl \
		lib/nausicaa/mehve/language/numerics/transcendental.fasl \
		lib/nausicaa/mehve/language/infix.fasl \
		lib/nausicaa/mehve/language/input-output.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_mehve_fasldir = $(bundledlibsdir)/nausicaa
nodist_lib_nausicaa_mehve_fasl_DATA = lib/nausicaa/mehve.fasl
EXTRA_DIST += lib/nausicaa/mehve.sls
CLEANFILES += lib/nausicaa/mehve.fasl
endif

lib/nausicaa/mehve/language/numerics/predicates.fasl: \
		lib/nausicaa/mehve/language/numerics/predicates.sls \
		lib/nausicaa.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_mehve_language_numerics_predicates_fasldir = $(bundledlibsdir)/nausicaa/mehve/language/numerics
nodist_lib_nausicaa_mehve_language_numerics_predicates_fasl_DATA = lib/nausicaa/mehve/language/numerics/predicates.fasl
EXTRA_DIST += lib/nausicaa/mehve/language/numerics/predicates.sls
CLEANFILES += lib/nausicaa/mehve/language/numerics/predicates.fasl
endif

lib/nausicaa/mehve/language/numerics/arithmetics.fasl: \
		lib/nausicaa/mehve/language/numerics/arithmetics.sls \
		lib/nausicaa.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_mehve_language_numerics_arithmetics_fasldir = $(bundledlibsdir)/nausicaa/mehve/language/numerics
nodist_lib_nausicaa_mehve_language_numerics_arithmetics_fasl_DATA = lib/nausicaa/mehve/language/numerics/arithmetics.fasl
EXTRA_DIST += lib/nausicaa/mehve/language/numerics/arithmetics.sls
CLEANFILES += lib/nausicaa/mehve/language/numerics/arithmetics.fasl
endif

lib/nausicaa/mehve/language/numerics/parts.fasl: \
		lib/nausicaa/mehve/language/numerics/parts.sls \
		lib/nausicaa.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_mehve_language_numerics_parts_fasldir = $(bundledlibsdir)/nausicaa/mehve/language/numerics
nodist_lib_nausicaa_mehve_language_numerics_parts_fasl_DATA = lib/nausicaa/mehve/language/numerics/parts.fasl
EXTRA_DIST += lib/nausicaa/mehve/language/numerics/parts.sls
CLEANFILES += lib/nausicaa/mehve/language/numerics/parts.fasl
endif

lib/nausicaa/mehve/language/numerics/transcendental.fasl: \
		lib/nausicaa/mehve/language/numerics/transcendental.sls \
		lib/nausicaa.fasl \
		lib/vicare/unsafe/operations.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_mehve_language_numerics_transcendental_fasldir = $(bundledlibsdir)/nausicaa/mehve/language/numerics
nodist_lib_nausicaa_mehve_language_numerics_transcendental_fasl_DATA = lib/nausicaa/mehve/language/numerics/transcendental.fasl
EXTRA_DIST += lib/nausicaa/mehve/language/numerics/transcendental.sls
CLEANFILES += lib/nausicaa/mehve/language/numerics/transcendental.fasl
endif

lib/nausicaa/mehve/language/infix.fasl: \
		lib/nausicaa/mehve/language/infix.sls \
		lib/nausicaa.fasl \
		lib/vicare/language-extensions/infix/parser-utils.fasl \
		lib/vicare/language-extensions/infix/tokens.fasl \
		lib/nausicaa/mehve/language/numerics/predicates.fasl \
		lib/nausicaa/mehve/language/numerics/arithmetics.fasl \
		lib/nausicaa/mehve/language/numerics/parts.fasl \
		lib/nausicaa/mehve/language/numerics/transcendental.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_mehve_language_infix_fasldir = $(bundledlibsdir)/nausicaa/mehve/language
nodist_lib_nausicaa_mehve_language_infix_fasl_DATA = lib/nausicaa/mehve/language/infix.fasl
EXTRA_DIST += lib/nausicaa/mehve/language/infix.sls
CLEANFILES += lib/nausicaa/mehve/language/infix.fasl
endif

lib/nausicaa/mehve/language/input-output.fasl: \
		lib/nausicaa/mehve/language/input-output.sls \
		lib/nausicaa.fasl \
		$(VICARE_NEW_BOOT)
	$(VICARE_COMPILE_RUN) --output $@ --compile-library $<

if WANT_NAUSICAA
lib_nausicaa_mehve_language_input_output_fasldir = $(bundledlibsdir)/nausicaa/mehve/language
nodist_lib_nausicaa_mehve_language_input_output_fasl_DATA = lib/nausicaa/mehve/language/input-output.fasl
EXTRA_DIST += lib/nausicaa/mehve/language/input-output.sls
CLEANFILES += lib/nausicaa/mehve/language/input-output.fasl
endif


### end of file
# Local Variables:
# mode: makefile-automake
# End: