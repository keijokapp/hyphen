#include <stdio.h>
#include <node_api.h>
#include <HsFFI.h>
#include <Rts.h>
#include "Test_stub.h"

#define NAPI_CALL(env, call)                                      \
  do {                                                            \
    napi_status status = (call);                                  \
    if (status != napi_ok) {                                      \
      const napi_extended_error_info* error_info = NULL;          \
      napi_get_last_error_info((env), &error_info);               \
      const char* err_message = error_info->error_message;        \
      bool is_pending;                                            \
      napi_is_exception_pending((env), &is_pending);              \
      if (!is_pending) {                                          \
        const char* message = (err_message == NULL)               \
            ? "empty error message"                               \
            : err_message;                                        \
        napi_throw_error((env), NULL, message);                   \
        return NULL;                                              \
      }                                                           \
    }                                                             \
  } while(0)

static napi_value
DoSomethingUseful(napi_env env, napi_callback_info info) {
  napi_status status;
  napi_value result;

  // printf("before\n");

  napi_value shit[99999];
  for (long i = 0; i < 1; i++) {
    napi_create_int32(env, i, &(shit[i]));
  }

  int i = fibonacci_hs(42);
  // printf("Fibonacci: %d\n", i);

  // printf("after\n");

  // Create a new, empty JS object.
  status = napi_create_int32(env, i, &result);
  if (status != napi_ok) return NULL;

  return result;
}

NAPI_MODULE_INIT() {
  RtsConfig rts_opts = defaultRtsConfig;
  rts_opts.rts_opts_enabled = RtsOptsNone;
  rts_opts.rts_opts = "--install-signal-handlers=no";
  hs_init_ghc(NULL, NULL, rts_opts);

  napi_value result;
  NAPI_CALL(env, napi_create_object(env, &result));

  napi_value exported_function;
  NAPI_CALL(env, napi_create_function(env,
                                      "doSomethingUseful",
                                      NAPI_AUTO_LENGTH,
                                      DoSomethingUseful,
                                      NULL,
                                      &exported_function));

  NAPI_CALL(env, napi_set_named_property(env,
                                         result,
                                         "doSomethingUseful",
                                         exported_function));

  return result;
}
