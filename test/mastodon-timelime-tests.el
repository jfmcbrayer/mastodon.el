(require 'el-mock)

(ert-deftest mastodon-timeline--define-get ()
  "Should define a function that displays timeline buffer."
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

(ert-deftest mastodon-timline--define-display ()
  "Should define a function that displays timeline data."
  (unwind-protect
      (with-mock
        (mock (mapcar (lambda () t) '(1 2 3)))
        (mock (point-min) => 1)
        (mock (point-max) => 9)
        (mock (replace-regexp "\n\n\n | " "\n | " nil 1 9))
        (mock (mastodon-media--inline-images))
        (mastodon-timeline--define-display "foobar"
                                           (lambda () t))
        (mastodon-foobar--display '(1 2 3)))))
