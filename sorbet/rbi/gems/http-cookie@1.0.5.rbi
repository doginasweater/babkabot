# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `http-cookie` gem.
# Please instead update this file by running `bin/tapioca gem http-cookie`.

module HTTP; end

# This class is used to represent an HTTP Cookie.
class HTTP::Cookie
  include ::Comparable

  # :call-seq:
  #     new(name, value = nil)
  #     new(name, value = nil, **attr_hash)
  #     new(**attr_hash)
  #
  # Creates a cookie object.  For each key of `attr_hash`, the setter
  # is called if defined and any error (typically ArgumentError or
  # TypeError) that is raised will be passed through.  Each key can be
  # either a downcased symbol or a string that may be mixed case.
  # Support for the latter may, however, be obsoleted in future when
  # Ruby 2.0's keyword syntax is adopted.
  #
  # If `value` is omitted or it is nil, an expiration cookie is
  # created unless `max_age` or `expires` (`expires_at`) is given.
  #
  # e.g.
  #
  #     new("uid", "a12345")
  #     new("uid", "a12345", :domain => 'example.org',
  #                          :for_domain => true, :expired => Time.now + 7*86400)
  #     new("name" => "uid", "value" => "a12345", "Domain" => 'www.example.org')
  #
  # @return [Cookie] a new instance of Cookie
  #
  # source://http-cookie//lib/http/cookie.rb#130
  def initialize(*args); end

  # Compares the cookie with another.  When there are many cookies with
  # the same name for a URL, the value of the smallest must be used.
  #
  # source://http-cookie//lib/http/cookie.rb#643
  def <=>(other); end

  # Tests if it is OK to accept this cookie considering its origin.
  # If either domain or path is missing, raises ArgumentError.  If
  # origin is missing, returns true.
  #
  # @return [Boolean]
  #
  # source://http-cookie//lib/http/cookie.rb#569
  def acceptable?; end

  # Tests if it is OK to accept this cookie if it is sent from a given
  # URI/URL, `uri`.
  #
  # @return [Boolean]
  #
  # source://http-cookie//lib/http/cookie.rb#550
  def acceptable_from_uri?(uri); end

  # The time this cookie was last accessed at.
  #
  # source://http-cookie//lib/http/cookie.rb#546
  def accessed_at; end

  # The time this cookie was last accessed at.
  #
  # source://http-cookie//lib/http/cookie.rb#546
  def accessed_at=(_arg0); end

  # Returns a string for use in the Cookie header, i.e. `name=value`
  # or `name="value"`.
  #
  # source://http-cookie//lib/http/cookie.rb#596
  def cookie_value; end

  # The time this cookie was created at.  This value is used as a base
  # date for interpreting the Max-Age attribute value.  See #expires.
  #
  # source://http-cookie//lib/http/cookie.rb#543
  def created_at; end

  # The time this cookie was created at.  This value is used as a base
  # date for interpreting the Max-Age attribute value.  See #expires.
  #
  # source://http-cookie//lib/http/cookie.rb#543
  def created_at=(_arg0); end

  # Returns the value of attribute domain.
  #
  # source://http-cookie//lib/http/cookie.rb#383
  def domain; end

  # See #domain.
  #
  # source://http-cookie//lib/http/cookie.rb#386
  def domain=(domain); end

  # Returns the domain attribute value as a DomainName object.
  #
  # source://http-cookie//lib/http/cookie.rb#431
  def domain_name; end

  # Returns the domain, with a dot prefixed only if the domain flag is
  # on.
  #
  # source://http-cookie//lib/http/cookie.rb#426
  def dot_domain; end

  # YAML serialization helper for Psych.
  #
  # source://http-cookie//lib/http/cookie.rb#659
  def encode_with(coder); end

  # Expires this cookie by setting the expires attribute value to a
  # past date.
  #
  # source://http-cookie//lib/http/cookie.rb#536
  def expire!; end

  # Tests if this cookie is expired by now, or by a given time.
  #
  # @return [Boolean]
  #
  # source://http-cookie//lib/http/cookie.rb#526
  def expired?(time = T.unsafe(nil)); end

  # source://http-cookie//lib/http/cookie.rb#485
  def expires; end

  # See #expires.
  #
  # source://http-cookie//lib/http/cookie.rb#490
  def expires=(t); end

  # source://http-cookie//lib/http/cookie.rb#485
  def expires_at; end

  # See #expires.
  #
  # source://http-cookie//lib/http/cookie.rb#490
  def expires_at=(t); end

  # The domain flag. (the opposite of host-only-flag)
  #
  # If this flag is true, this cookie will be sent to any host in the
  # \#domain, including the host domain itself.  If it is false, this
  # cookie will be sent only to the host indicated by the #domain.
  #
  # source://http-cookie//lib/http/cookie.rb#438
  def for_domain; end

  # The domain flag. (the opposite of host-only-flag)
  #
  # If this flag is true, this cookie will be sent to any host in the
  # \#domain, including the host domain itself.  If it is false, this
  # cookie will be sent only to the host indicated by the #domain.
  #
  # source://http-cookie//lib/http/cookie.rb#438
  def for_domain=(_arg0); end

  # The domain flag. (the opposite of host-only-flag)
  #
  # If this flag is true, this cookie will be sent to any host in the
  # \#domain, including the host domain itself.  If it is false, this
  # cookie will be sent only to the host indicated by the #domain.
  #
  # source://http-cookie//lib/http/cookie.rb#438
  def for_domain?; end

  # The HttpOnly flag. (http-only-flag)
  #
  # A cookie with this flag on should be hidden from a client script.
  #
  # source://http-cookie//lib/http/cookie.rb#476
  def httponly; end

  # The HttpOnly flag. (http-only-flag)
  #
  # A cookie with this flag on should be hidden from a client script.
  #
  # source://http-cookie//lib/http/cookie.rb#476
  def httponly=(_arg0); end

  # The HttpOnly flag. (http-only-flag)
  #
  # A cookie with this flag on should be hidden from a client script.
  #
  # source://http-cookie//lib/http/cookie.rb#476
  def httponly?; end

  # YAML deserialization helper for Syck.
  #
  # source://http-cookie//lib/http/cookie.rb#666
  def init_with(coder); end

  # source://http-cookie//lib/http/cookie.rb#635
  def inspect; end

  # Returns the value of attribute max_age.
  #
  # source://http-cookie//lib/http/cookie.rb#504
  def max_age; end

  # See #max_age.
  #
  # source://http-cookie//lib/http/cookie.rb#507
  def max_age=(sec); end

  # Returns the value of attribute name.
  #
  # source://http-cookie//lib/http/cookie.rb#347
  def name; end

  # See #name.
  #
  # source://http-cookie//lib/http/cookie.rb#350
  def name=(name); end

  # Returns the value of attribute origin.
  #
  # source://http-cookie//lib/http/cookie.rb#450
  def origin; end

  # See #origin.
  #
  # source://http-cookie//lib/http/cookie.rb#453
  def origin=(origin); end

  # Returns the value of attribute path.
  #
  # source://http-cookie//lib/http/cookie.rb#441
  def path; end

  # See #path.
  #
  # source://http-cookie//lib/http/cookie.rb#444
  def path=(path); end

  # The secure flag. (secure-only-flag)
  #
  # A cookie with this flag on should only be sent via a secure
  # protocol like HTTPS.
  #
  # source://http-cookie//lib/http/cookie.rb#470
  def secure; end

  # The secure flag. (secure-only-flag)
  #
  # A cookie with this flag on should only be sent via a secure
  # protocol like HTTPS.
  #
  # source://http-cookie//lib/http/cookie.rb#470
  def secure=(_arg0); end

  # The secure flag. (secure-only-flag)
  #
  # A cookie with this flag on should only be sent via a secure
  # protocol like HTTPS.
  #
  # source://http-cookie//lib/http/cookie.rb#470
  def secure?; end

  # The session flag. (the opposite of persistent-flag)
  #
  # A cookie with this flag on should be hidden from a client script.
  #
  # source://http-cookie//lib/http/cookie.rb#482
  def session; end

  # The session flag. (the opposite of persistent-flag)
  #
  # A cookie with this flag on should be hidden from a client script.
  #
  # source://http-cookie//lib/http/cookie.rb#482
  def session?; end

  # Returns a string for use in the Set-Cookie header.  If necessary
  # information like a path or domain (when `for_domain` is set) is
  # missing, RuntimeError is raised.  It is always the best to set an
  # origin before calling this method.
  #
  # source://http-cookie//lib/http/cookie.rb#605
  def set_cookie_value; end

  # Returns a string for use in the Cookie header, i.e. `name=value`
  # or `name="value"`.
  #
  # source://http-cookie//lib/http/cookie.rb#596
  def to_s; end

  # YAML serialization helper for Syck.
  #
  # source://http-cookie//lib/http/cookie.rb#654
  def to_yaml_properties; end

  # Tests if it is OK to send this cookie to a given `uri`.  A
  # RuntimeError is raised if the cookie's domain is unknown.
  #
  # @return [Boolean]
  #
  # source://http-cookie//lib/http/cookie.rb#584
  def valid_for_uri?(uri); end

  # Returns the value of attribute value.
  #
  # source://http-cookie//lib/http/cookie.rb#364
  def value; end

  # See #value.
  #
  # source://http-cookie//lib/http/cookie.rb#367
  def value=(value); end

  # YAML deserialization helper for Psych.
  #
  # source://http-cookie//lib/http/cookie.rb#671
  def yaml_initialize(tag, map); end

  class << self
    # Takes an array of cookies and returns a string for use in the
    # Cookie header, like "name1=value2; name2=value2".
    #
    # source://http-cookie//lib/http/cookie.rb#331
    def cookie_value(cookies); end

    # Parses a Cookie header value into a hash of name-value string
    # pairs.  The first appearance takes precedence if multiple pairs
    # with the same name occur.
    #
    # source://http-cookie//lib/http/cookie.rb#338
    def cookie_value_to_hash(cookie_value); end

    # Parses a Set-Cookie header value `set_cookie` assuming that it
    # is sent from a source URI/URL `origin`, and returns an array of
    # Cookie objects.  Parts (separated by commas) that are malformed
    # or considered unacceptable are silently ignored.
    #
    # If a block is given, each cookie object is passed to the block.
    #
    # Available option keywords are below:
    #
    # :created_at
    # : The creation time of the cookies parsed.
    #
    # :logger
    # : Logger object useful for debugging
    #
    # ### Compatibility Note for Mechanize::Cookie users
    #
    # * Order of parameters changed in HTTP::Cookie.parse:
    #
    #         Mechanize::Cookie.parse(uri, set_cookie[, log])
    #
    #         HTTP::Cookie.parse(set_cookie, uri[, :logger => # log])
    #
    # * HTTP::Cookie.parse does not accept nil for `set_cookie`.
    #
    # * HTTP::Cookie.parse does not yield nil nor include nil in an
    #   returned array.  It simply ignores unparsable parts.
    #
    # * HTTP::Cookie.parse is made to follow RFC 6265 to the extent
    #   not terribly breaking interoperability with broken
    #   implementations.  In particular, it is capable of parsing
    #   cookie definitions containing double-quotes just as naturally
    #   expected.
    #
    # source://http-cookie//lib/http/cookie.rb#273
    def parse(set_cookie, origin, options = T.unsafe(nil), &block); end

    # Tests if +target_path+ is under +base_path+ as described in RFC
    # 6265 5.1.4.  +base_path+ must be an absolute path.
    # +target_path+ may be empty, in which case it is treated as the
    # root path.
    #
    # e.g.
    #
    #         path_match?('/admin/', '/admin/index') == true
    #         path_match?('/admin/', '/Admin/index') == false
    #         path_match?('/admin/', '/admin/') == true
    #         path_match?('/admin/', '/admin') == false
    #
    #         path_match?('/admin', '/admin') == true
    #         path_match?('/admin', '/Admin') == false
    #         path_match?('/admin', '/admins') == false
    #         path_match?('/admin', '/admin/') == true
    #         path_match?('/admin', '/admin/index') == true
    #
    # @return [Boolean]
    #
    # source://http-cookie//lib/http/cookie.rb#229
    def path_match?(base_path, target_path); end
  end
end

# Maximum number of cookies per domain (RFC 6265 6.1 requires 50 at
# least)
#
# source://http-cookie//lib/http/cookie.rb#19
HTTP::Cookie::MAX_COOKIES_PER_DOMAIN = T.let(T.unsafe(nil), Integer)

# Maximum number of cookies total (RFC 6265 6.1 requires 3000 at
# least)
#
# source://http-cookie//lib/http/cookie.rb#22
HTTP::Cookie::MAX_COOKIES_TOTAL = T.let(T.unsafe(nil), Integer)

# Maximum number of bytes per cookie (RFC 6265 6.1 requires 4096 at
# least)
#
# source://http-cookie//lib/http/cookie.rb#16
HTTP::Cookie::MAX_LENGTH = T.let(T.unsafe(nil), Integer)

# source://http-cookie//lib/http/cookie.rb#27
HTTP::Cookie::PERSISTENT_PROPERTIES = T.let(T.unsafe(nil), Array)

class HTTP::Cookie::Scanner < ::StringScanner
  # @return [Scanner] a new instance of Scanner
  #
  # source://http-cookie//lib/http/cookie/scanner.rb#18
  def initialize(string, logger = T.unsafe(nil)); end

  # source://http-cookie//lib/http/cookie/scanner.rb#104
  def parse_cookie_date(s); end

  # source://http-cookie//lib/http/cookie/scanner.rb#218
  def scan_cookie; end

  # source://http-cookie//lib/http/cookie/scanner.rb#34
  def scan_dquoted; end

  # source://http-cookie//lib/http/cookie/scanner.rb#47
  def scan_name; end

  # source://http-cookie//lib/http/cookie/scanner.rb#73
  def scan_name_value(comma_as_separator = T.unsafe(nil)); end

  # source://http-cookie//lib/http/cookie/scanner.rb#156
  def scan_set_cookie; end

  # source://http-cookie//lib/http/cookie/scanner.rb#53
  def scan_value(comma_as_separator = T.unsafe(nil)); end

  # source://http-cookie//lib/http/cookie/scanner.rb#30
  def skip_wsp; end

  private

  # source://http-cookie//lib/http/cookie/scanner.rb#85
  def tuple_to_time(day_of_month, month, year, time); end

  class << self
    # source://http-cookie//lib/http/cookie/scanner.rb#24
    def quote(s); end
  end
end

# source://http-cookie//lib/http/cookie/scanner.rb#13
HTTP::Cookie::Scanner::RE_BAD_CHAR = T.let(T.unsafe(nil), Regexp)

# A pattern that matches the comma in a (typically date) value.
#
# source://http-cookie//lib/http/cookie/scanner.rb#16
HTTP::Cookie::Scanner::RE_COOKIE_COMMA = T.let(T.unsafe(nil), Regexp)

# A pattern that matches a cookie name or attribute name which may
# be empty, capturing trailing whitespace.
#
# source://http-cookie//lib/http/cookie/scanner.rb#11
HTTP::Cookie::Scanner::RE_NAME = T.let(T.unsafe(nil), Regexp)

# Whitespace.
#
# source://http-cookie//lib/http/cookie/scanner.rb#7
HTTP::Cookie::Scanner::RE_WSP = T.let(T.unsafe(nil), Regexp)

# :stopdoc:
#
# source://http-cookie//lib/http/cookie.rb#25
HTTP::Cookie::UNIX_EPOCH = T.let(T.unsafe(nil), Time)

# source://http-cookie//lib/http/cookie/version.rb#3
HTTP::Cookie::VERSION = T.let(T.unsafe(nil), String)

# This class is used to manage the Cookies that have been returned from
# any particular website.
class HTTP::CookieJar
  include ::Enumerable

  # Generates a new cookie jar.
  #
  # Available option keywords are as below:
  #
  # :store
  # : The store class that backs this jar. (default: `:hash`)
  # A symbol addressing a store class, a store class, or an instance
  # of a store class is accepted.  Symbols are mapped to store
  # classes, like `:hash` to HTTP::CookieJar::HashStore and `:mozilla`
  # to HTTP::CookieJar::MozillaStore.
  #
  # Any options given are passed through to the initializer of the
  # specified store class.  For example, the `:mozilla`
  # (HTTP::CookieJar::MozillaStore) store class requires a `:filename`
  # option.  See individual store classes for details.
  #
  # @return [CookieJar] a new instance of CookieJar
  #
  # source://http-cookie//lib/http/cookie_jar.rb#69
  def initialize(options = T.unsafe(nil)); end

  # Adds a cookie to the jar if it is acceptable, and returns self in
  # any case.  A given cookie must have domain and path attributes
  # set, or ArgumentError is raised.
  #
  # Whether a cookie with the `for_domain` flag on overwrites another
  # with the flag off or vice versa depends on the store used.  See
  # individual store classes for that matter.
  #
  # ### Compatibility Note for Mechanize::Cookie users
  #
  # In HTTP::Cookie, each cookie object can store its origin URI
  # (cf. #origin).  While the origin URI of a cookie can be set
  # manually by #origin=, one is typically given in its generation.
  # To be more specific, HTTP::Cookie.new takes an `:origin` option
  # and HTTP::Cookie.parse takes one via the second argument.
  #
  #       # Mechanize::Cookie
  #       jar.add(origin, cookie)
  #       jar.add!(cookie)    # no acceptance check is performed
  #
  #       # HTTP::Cookie
  #       jar.origin = origin
  #       jar.add(cookie)     # acceptance check is performed
  #
  # source://http-cookie//lib/http/cookie_jar.rb#105
  def <<(cookie); end

  # Adds a cookie to the jar if it is acceptable, and returns self in
  # any case.  A given cookie must have domain and path attributes
  # set, or ArgumentError is raised.
  #
  # Whether a cookie with the `for_domain` flag on overwrites another
  # with the flag off or vice versa depends on the store used.  See
  # individual store classes for that matter.
  #
  # ### Compatibility Note for Mechanize::Cookie users
  #
  # In HTTP::Cookie, each cookie object can store its origin URI
  # (cf. #origin).  While the origin URI of a cookie can be set
  # manually by #origin=, one is typically given in its generation.
  # To be more specific, HTTP::Cookie.new takes an `:origin` option
  # and HTTP::Cookie.parse takes one via the second argument.
  #
  #       # Mechanize::Cookie
  #       jar.add(origin, cookie)
  #       jar.add!(cookie)    # no acceptance check is performed
  #
  #       # HTTP::Cookie
  #       jar.origin = origin
  #       jar.add(cookie)     # acceptance check is performed
  #
  # source://http-cookie//lib/http/cookie_jar.rb#105
  def add(cookie); end

  # Removes expired cookies and returns self.  If `session` is true,
  # all session cookies are removed as well.
  #
  # source://http-cookie//lib/http/cookie_jar.rb#340
  def cleanup(session = T.unsafe(nil)); end

  # Clears the cookie jar and returns self.
  #
  # source://http-cookie//lib/http/cookie_jar.rb#333
  def clear; end

  # Gets an array of cookies sorted by the path and creation time.  If
  # `url` is given, only ones that should be sent to the URL/URI are
  # selected, with the access time of each of them updated.
  #
  # source://http-cookie//lib/http/cookie_jar.rb#130
  def cookies(url = T.unsafe(nil)); end

  # Deletes a cookie that has the same name, domain and path as a
  # given cookie from the jar and returns self.
  #
  # How the `for_domain` flag value affects the set of deleted cookies
  # depends on the store used.  See individual store classes for that
  # matter.
  #
  # source://http-cookie//lib/http/cookie_jar.rb#122
  def delete(cookie); end

  # Iterates over all cookies that are not expired in no particular
  # order.
  #
  # An optional argument `uri` specifies a URI/URL indicating the
  # destination of the cookies being selected.  Every cookie yielded
  # should be good to send to the given URI,
  # i.e. cookie.valid_for_uri?(uri) evaluates to true.
  #
  # If (and only if) the `uri` option is given, last access time of
  # each cookie is updated to the current time.
  #
  # source://http-cookie//lib/http/cookie_jar.rb#155
  def each(uri = T.unsafe(nil), &block); end

  # Tests if the jar is empty.  If `url` is given, tests if there is
  # no cookie for the URL.
  #
  # @return [Boolean]
  #
  # source://http-cookie//lib/http/cookie_jar.rb#136
  def empty?(url = T.unsafe(nil)); end

  # call-seq:
  #   jar.load(filename_or_io, **options)
  #   jar.load(filename_or_io, format = :yaml, **options)
  #
  # Loads cookies recorded in a file or an IO in the format specified
  # into the jar and returns self.  If a given object responds to
  # \#read it is taken as an IO, or taken as a filename otherwise.
  #
  # Available option keywords are below:
  #
  # * `:format`
  #
  #     Specifies the format for loading.  A saver class, a symbol
  #     addressing a saver class, or a pre-generated instance of a
  #     saver class is accepted.
  #
  #     <dl class="rdoc-list note-list">
  #       <dt>:yaml</dt>
  #       <dd>YAML structure (default)</dd>
  #       <dt>:cookiestxt</dt>
  #       <dd>Mozilla's cookies.txt format</dd>
  #     </dl>
  #
  # All options given are passed through to the underlying cookie
  # saver module's constructor.
  #
  # source://http-cookie//lib/http/cookie_jar.rb#294
  def load(readable, *options); end

  # Parses a Set-Cookie field value `set_cookie` assuming that it is
  # sent from a source URL/URI `origin`, and adds the cookies parsed
  # as valid and considered acceptable to the jar.  Returns an array
  # of cookies that have been added.
  #
  # If a block is given, it is called for each cookie and the cookie
  # is added only if the block returns a true value.
  #
  # `jar.parse(set_cookie, origin)` is a shorthand for this:
  #
  #         HTTP::Cookie.parse(set_cookie, origin) { |cookie|
  #           jar.add(cookie)
  #         }
  #
  # See HTTP::Cookie.parse for available options.
  #
  # source://http-cookie//lib/http/cookie_jar.rb#183
  def parse(set_cookie, origin, options = T.unsafe(nil)); end

  # call-seq:
  #   jar.save(filename_or_io, **options)
  #   jar.save(filename_or_io, format = :yaml, **options)
  #
  # Saves the cookie jar into a file or an IO in the format specified
  # and returns self.  If a given object responds to #write it is
  # taken as an IO, or taken as a filename otherwise.
  #
  # Available option keywords are below:
  #
  # * `:format`
  #
  #     Specifies the format for saving.  A saver class, a symbol
  #     addressing a saver class, or a pre-generated instance of a
  #     saver class is accepted.
  #
  #     <dl class="rdoc-list note-list">
  #       <dt>:yaml</dt>
  #       <dd>YAML structure (default)</dd>
  #       <dt>:cookiestxt</dt>
  #       <dd>Mozilla's cookies.txt format</dd>
  #     </dl>
  #
  # * `:session`
  #
  #     <dl class="rdoc-list note-list">
  #       <dt>true</dt>
  #       <dd>Save session cookies as well.</dd>
  #       <dt>false</dt>
  #       <dd>Do not save session cookies. (default)</dd>
  #     </dl>
  #
  # All options given are passed through to the underlying cookie
  # saver module's constructor.
  #
  # source://http-cookie//lib/http/cookie_jar.rb#231
  def save(writable, *options); end

  # Returns the value of attribute store.
  #
  # source://http-cookie//lib/http/cookie_jar.rb#30
  def store; end

  private

  # source://http-cookie//lib/http/cookie_jar.rb#32
  def get_impl(base, value, *args); end

  # The copy constructor.  Not all backend store classes support cloning.
  #
  # source://http-cookie//lib/http/cookie_jar.rb#78
  def initialize_copy(other); end

  class << self
    # source://http-cookie//lib/http/cookie_jar.rb#10
    def const_missing(name); end
  end
end

# An abstract superclass for all saver classes.
class HTTP::CookieJar::AbstractSaver
  # :call-seq:
  #   new(**options)
  #
  # Called by the constructor of each subclass using super().
  #
  # @return [AbstractSaver] a new instance of AbstractSaver
  #
  # source://http-cookie//lib/http/cookie_jar/abstract_saver.rb#41
  def initialize(options = T.unsafe(nil)); end

  # Implements HTTP::CookieJar#load().
  #
  # This is an abstract method that each subclass must override.
  #
  # source://http-cookie//lib/http/cookie_jar/abstract_saver.rb#62
  def load(io, jar); end

  # Implements HTTP::CookieJar#save().
  #
  # This is an abstract method that each subclass must override.
  #
  # source://http-cookie//lib/http/cookie_jar/abstract_saver.rb#55
  def save(io, jar); end

  private

  # Defines options and their default values.
  #
  # source://http-cookie//lib/http/cookie_jar/abstract_saver.rb#32
  def default_options; end

  class << self
    # source://http-cookie//lib/http/cookie_jar/abstract_saver.rb#26
    def class_to_symbol(klass); end

    # Gets an implementation class by the name, optionally trying to
    # load "http/cookie_jar/*_saver" if not found.  If loading fails,
    # IndexError is raised.
    #
    # source://http-cookie//lib/http/cookie_jar/abstract_saver.rb#11
    def implementation(symbol); end

    # source://http-cookie//lib/http/cookie_jar/abstract_saver.rb#22
    def inherited(subclass); end
  end
end

# An abstract superclass for all store classes.
class HTTP::CookieJar::AbstractStore
  include ::MonitorMixin
  include ::Enumerable

  # :call-seq:
  #   new(**options)
  #
  # Called by the constructor of each subclass using super().
  #
  # @return [AbstractStore] a new instance of AbstractStore
  #
  # source://http-cookie//lib/http/cookie_jar/abstract_store.rb#44
  def initialize(options = T.unsafe(nil)); end

  # Implements HTTP::CookieJar#add().
  #
  # This is an abstract method that each subclass must override.
  #
  # source://http-cookie//lib/http/cookie_jar/abstract_store.rb#63
  def add(cookie); end

  # Implements HTTP::CookieJar#cleanup().
  #
  # This is an abstract method that each subclass must override.
  #
  # source://http-cookie//lib/http/cookie_jar/abstract_store.rb#113
  def cleanup(session = T.unsafe(nil)); end

  # Implements HTTP::CookieJar#clear().
  #
  # This is an abstract method that each subclass must override.
  #
  # source://http-cookie//lib/http/cookie_jar/abstract_store.rb#106
  def clear; end

  # Implements HTTP::CookieJar#delete().
  #
  # This is an abstract method that each subclass must override.
  #
  # source://http-cookie//lib/http/cookie_jar/abstract_store.rb#70
  def delete(cookie); end

  # Iterates over all cookies that are not expired.
  #
  # An optional argument +uri+ specifies a URI object indicating the
  # destination of the cookies being selected.  Every cookie yielded
  # should be good to send to the given URI,
  # i.e. cookie.valid_for_uri?(uri) evaluates to true.
  #
  # If (and only if) the +uri+ option is given, last access time of
  # each cookie is updated to the current time.
  #
  # This is an abstract method that each subclass must override.
  #
  # source://http-cookie//lib/http/cookie_jar/abstract_store.rb#85
  def each(uri = T.unsafe(nil), &block); end

  # Implements HTTP::CookieJar#empty?().
  #
  # @return [Boolean]
  #
  # source://http-cookie//lib/http/cookie_jar/abstract_store.rb#98
  def empty?; end

  private

  # Defines options and their default values.
  #
  # source://http-cookie//lib/http/cookie_jar/abstract_store.rb#35
  def default_options; end

  # This is an abstract method that each subclass must override.
  #
  # source://http-cookie//lib/http/cookie_jar/abstract_store.rb#56
  def initialize_copy(other); end

  class << self
    # source://http-cookie//lib/http/cookie_jar/abstract_store.rb#29
    def class_to_symbol(klass); end

    # Gets an implementation class by the name, optionally trying to
    # load "http/cookie_jar/*_store" if not found.  If loading fails,
    # IndexError is raised.
    #
    # source://http-cookie//lib/http/cookie_jar/abstract_store.rb#14
    def implementation(symbol); end

    # source://http-cookie//lib/http/cookie_jar/abstract_store.rb#25
    def inherited(subclass); end
  end
end

# CookiestxtSaver saves and loads cookies in the cookies.txt format.
class HTTP::CookieJar::CookiestxtSaver < ::HTTP::CookieJar::AbstractSaver
  # source://http-cookie//lib/http/cookie_jar/cookiestxt_saver.rb#32
  def load(io, jar); end

  # source://http-cookie//lib/http/cookie_jar/cookiestxt_saver.rb#24
  def save(io, jar); end

  private

  # Serializes the cookie into a cookies.txt line.
  #
  # source://http-cookie//lib/http/cookie_jar/cookiestxt_saver.rb#56
  def cookie_to_record(cookie); end

  # source://http-cookie//lib/http/cookie_jar/cookiestxt_saver.rb#40
  def default_options; end

  # Parses a line from cookies.txt and returns a cookie object if the
  # line represents a cookie record or returns nil otherwise.
  #
  # source://http-cookie//lib/http/cookie_jar/cookiestxt_saver.rb#72
  def parse_record(line); end
end

# source://http-cookie//lib/http/cookie_jar/cookiestxt_saver.rb#49
HTTP::CookieJar::CookiestxtSaver::False = T.let(T.unsafe(nil), String)

# source://http-cookie//lib/http/cookie_jar/cookiestxt_saver.rb#51
HTTP::CookieJar::CookiestxtSaver::HTTPONLY_PREFIX = T.let(T.unsafe(nil), String)

# source://http-cookie//lib/http/cookie_jar/cookiestxt_saver.rb#52
HTTP::CookieJar::CookiestxtSaver::RE_HTTPONLY_PREFIX = T.let(T.unsafe(nil), Regexp)

# :stopdoc:
#
# source://http-cookie//lib/http/cookie_jar/cookiestxt_saver.rb#48
HTTP::CookieJar::CookiestxtSaver::True = T.let(T.unsafe(nil), String)

# A store class that uses a hash-based cookie store.
#
# In this store, cookies that share the same name, domain and path
# will overwrite each other regardless of the `for_domain` flag
# value.  This store is built after the storage model described in
# RFC 6265 5.3 where there is no mention of how the host-only-flag
# affects in storing cookies.  On the other hand, in MozillaStore
# two cookies with the same name, domain and path coexist as long as
# they differ in the `for_domain` flag value, which means they need
# to be expired individually.
class HTTP::CookieJar::HashStore < ::HTTP::CookieJar::AbstractStore
  # :call-seq:
  #   new(**options)
  #
  # Generates a hash based cookie store.
  #
  # Available option keywords are as below:
  #
  # :gc_threshold
  # : GC threshold; A GC happens when this many times cookies have
  # been stored (default: `HTTP::Cookie::MAX_COOKIES_TOTAL / 20`)
  #
  # @return [HashStore] a new instance of HashStore
  #
  # source://http-cookie//lib/http/cookie_jar/hash_store.rb#32
  def initialize(options = T.unsafe(nil)); end

  # source://http-cookie//lib/http/cookie_jar/hash_store.rb#54
  def add(cookie); end

  # source://http-cookie//lib/http/cookie_jar/hash_store.rb#111
  def cleanup(session = T.unsafe(nil)); end

  # source://http-cookie//lib/http/cookie_jar/hash_store.rb#106
  def clear; end

  # source://http-cookie//lib/http/cookie_jar/hash_store.rb#16
  def default_options; end

  # source://http-cookie//lib/http/cookie_jar/hash_store.rb#61
  def delete(cookie); end

  # :yield: cookie
  #
  # source://http-cookie//lib/http/cookie_jar/hash_store.rb#67
  def each(uri = T.unsafe(nil)); end

  private

  # The copy constructor.  This store class supports cloning.
  #
  # source://http-cookie//lib/http/cookie_jar/hash_store.rb#50
  def initialize_copy(other); end
end

# YAMLSaver saves and loads cookies in the YAML format.  It can load a
# YAML file saved by Mechanize, but the saving format is not
# compatible with older versions of Mechanize (< 2.7).
class HTTP::CookieJar::YAMLSaver < ::HTTP::CookieJar::AbstractSaver
  # source://http-cookie//lib/http/cookie_jar/yaml_saver.rb#22
  def load(io, jar); end

  # source://http-cookie//lib/http/cookie_jar/yaml_saver.rb#18
  def save(io, jar); end

  private

  # source://http-cookie//lib/http/cookie_jar/yaml_saver.rb#73
  def default_options; end

  # source://http-cookie//lib/http/cookie_jar/yaml_saver.rb#78
  def load_yaml(yaml); end
end
