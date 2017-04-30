(require 'el-mock)

(ert-deftest mastodon-timeline--define-get ()
  "Should define a function that displays timeline data."
  (unwind-protect
      (with-mock
        (mock (mastodon-http--api "timeline/foobar") => "this-is-a-url-string")
        (mock (mastodon-http--get-json "this-is-a-url-string") => "json-content")
        (mock (switch-to-buffer "*mastodon-foobar*"))
        (mock (mastodon-timeline--display "json-content"))
        (mock (mastodon-mode))
        (mastodon-timeline--define-get "timeline/foobar" "foobar")
        (mastodon-foobar--get-timeline))
    (kill-buffer "*mastodon-foobar*")))
