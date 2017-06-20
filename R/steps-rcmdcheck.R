RCMDcheck <- R6Class(
  "RCMDcheck", inherit = TicStep,

  public = list(
    initialize = function(warnings_are_errors = TRUE, notes_are_errors = FALSE, args = "--no-manual") {
      private$warnings_are_errors <- warnings_are_errors
      private$notes_are_errors <- notes_are_errors
      private$args <- args
    },

    run = function() {
      res <- rcmdcheck::rcmdcheck(args = private$args)
      if (length(res$errors) > 0) {
        stopc("Errors found.")
      }
      if (private$warnings_are_errors && length(res$warnings) > 0) {
        stopc("Warnings found, and warnings_are_errors is set.")
      }
      if (private$notes_are_errors && length(res$notes) > 0) {
        stopc("Notes found, and notes_are_errors is set.")
      }
    },

    prepare = function() {
      verify_install("rcmdcheck")
    }
  ),

  private = list(
    warnings_are_errors = NULL,
    notes_are_errors = NULL,
    args = NULL
  )
)

#' @export
step_rcmdcheck <- RCMDcheck$new