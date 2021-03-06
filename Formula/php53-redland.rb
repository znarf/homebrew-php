require 'formula'
require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Redland < AbstractPhp53Extension
  init
  homepage 'http://librdf.org'
  url 'http://download.librdf.org/source/redland-bindings-1.0.16.1.tar.gz'
  sha1 '98c20b64cf5e99cbf29fcb84490e73e2a828213a'

  depends_on 'pkg-config' => :build
  depends_on 'redland'
  depends_on 'raptor'
  depends_on 'rasqal'

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.append 'PKG_CONFIG_LIBDIR', "#{(Formula.factory('redland')).lib}/pkgconfig", ':'
    ENV.append 'PKG_CONFIG_LIBDIR', "#{(Formula.factory('raptor')).lib}/pkgconfig", ':'
    ENV.append 'PKG_CONFIG_LIBDIR', "#{(Formula.factory('rasqal')).lib}/pkgconfig", ':'

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --with-php
      --with-php-linking=dylib
    ]

    system "./configure", *args
    system "make"
    prefix.install "php/#{extension}.dylib"
    write_config_file unless build.include? "without-config-file"
  end

  def module_path
    prefix / "#{extension}.dylib"
  end
end
