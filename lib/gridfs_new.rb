require 'mongo'
require 'rack/request'
require 'rack/utils'
begin 
  require 'rack/conditional_get'
rescue LoadError => e
  require 'rack/conditionalget'
end

class Rack::GridFSNew
  
  VERSION = '0.0.1'
  
  def initialize app, opts={}
    @app = app
    @db = opts[:db]
    @prefix = (opts[:prefix] || 'gridfs').gsub(/^\/|\/$/, '')
    @cache_control = opts[:cache_control] || 'no-cache'
  end
  
  def call env
    dup._call env
  end
  
  def _call env
    req = Rack::Request.new env
    if under_prefix? req
      file = find_file req
      response_for(file, req)
    else
      @app.call env
    end
  end
  
  private
    
    def response_for(file, request)
      [200, headers(file), file]
    end
    
    def headers(file)
      content_type = file.content_type
      content_type ='image/bmp' if content_type.end_with?('bmp')
      { 'Content-Type' => content_type }
    end
    
    def under_prefix? req
    	req.path_info =~ %r|^/#@prefix/(.*)|
    end
  
    def id_or_filename req
    	str = req.path_info.sub %r|^/#@prefix/|, ''
    	if BSON::ObjectId.legal? str
    	  BSON::ObjectId.from_string str
    	else
    	  Rack::Utils.unescape str
    	end
    end
    
    def find_file req
    	str = id_or_filename req
    	if str.is_a? BSON::ObjectId
    	  return @db.fs.find({_id: str}).first
    	else
    	  return @db.fs.find({
    	    '$or' => [
    	      {filename: str},
    	      {filename: "/#{str}"}
    	    ]
    	  }).first
      end
    end
end
