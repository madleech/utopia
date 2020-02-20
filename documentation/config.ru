#!/usr/bin/env rackup
# frozen_string_literal: true

require_relative 'config/environment'

self.freeze_app

if RACK_ENV == :production
	# Handle exceptions in production with a error page and send an email notification:
	use Utopia::Exceptions::Handler
	use Utopia::Exceptions::Mailer
else
	# We want to propate exceptions up when running tests:
	use Rack::ShowExceptions unless RACK_ENV == :test
	
	# Serve the public directory in a similar way to the web server:
	use Utopia::Static, root: 'public'
end

use Rack::Sendfile

use Utopia::Redirection::Rewrite,
	'/' => '/wiki/index'

use Utopia::Redirection::DirectoryIndex

use Utopia::Redirection::Errors,
	404 => '/errors/file-not-found'

use Utopia::Localization,
	:default_locale => 'en',
	:locales => ['en', 'de', 'ja', 'zh']

use Utopia::Controller

use Utopia::Static

# Serve dynamic content
use Utopia::Content

run lambda { |env| [404, {}, []] }
