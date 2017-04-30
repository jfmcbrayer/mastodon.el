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
    (fmakunbound 'mastodon-foobar--get-timeline)
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
        (mastodon-foobar--display '(1 2 3)))
    (fmakunbound 'mastodon-foobar--display)))

(ert-deftest mastodon-timeline--define-update-from ()
  "Should define an update function."
  (unwind-protect
      (with-mock
        (mock (point) => 2)
        (mock (funcall (lambda () t)) => "json-data")
        (mock (point-min) => 1)
        (mock (mastodon-foobar--display "json-data"))
        (mock (goto-char *) :times 2)
        (mastodon-timeline--define-update-from "foobar"
                                               (lambda () t)
                                               #'point-min
                                               "baz")
        (mastodon-foobar--update-baz))
    (fmakunbound 'mastodon-foobar--update-baz)))

(ert-deftest mastodon-timeline--define-update-from-2 ()
  "Should define an update function that does nil when there are no updates."
  (unwind-protect
      (with-mock
        (mock (funcall (lambda () t)))
        (mastodon-timeline--define-update-from "foobar"
                                               (lambda () t)
                                               #'point-max
                                               "nil")
        (mastodon-foobar--update-nil))
    (fmakunbound 'mastodon-foobar--update-nil)))
