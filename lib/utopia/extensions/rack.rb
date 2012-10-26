# Copyright, 2012, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'rack'

class Rack::Request
	def url_with_path(path = "")
		url = scheme + "://"
		url << host

		if scheme == "https" && port != 443 || scheme == "http" && port != 80
			url << ":#{port}"
		end

		url << path
	end
end

class Rack::Response
	def do_not_cache!
		self["Cache-Control"] = "no-cache, must-revalidate"
		self["Expires"] = Time.now.httpdate
	end
	
	def cache!(duration = 3600)
		unless (self["Cache-Control"] || "").match(/no-cache/)
			self["Cache-Control"] = "public, max-age=#{duration}"
			self["Expires"] = (Time.now + duration).httpdate
		end
	end
	
	def content_type!(value)
		self["Content-Type"] = value.to_s
	end
end
