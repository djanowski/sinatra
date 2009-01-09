require 'test/spec'
require 'sinatra/base'
require 'sinatra/test'

describe 'Sinatra::Stage' do
  include Sinatra::Test

  it 'includes Rack::Utils' do
    Sinatra::Stage.should.include Rack::Utils
  end

  it 'can be used as a Rack application' do
    mock_app {
      get '/' do
        'Hello World'
      end
    }
    @app.should.respond_to :call

    request = Rack::MockRequest.new(@app)
    response = request.get('/')
    response.should.be.ok
    response.body.should.equal 'Hello World'
  end

  it 'can be used as Rack middleware' do
    app = lambda { |env| [200, {}, ['Goodbye World']] }
    mock_middleware =
      mock_app {
        get '/' do
          'Hello World'
        end
        get '/goodbye' do
          @app.call(request.env)
        end
      }
    middleware = mock_middleware.new(app)
    middleware.app.should.be app

    request = Rack::MockRequest.new(middleware)
    response = request.get('/')
    response.should.be.ok
    response.body.should.equal 'Hello World'

    response = request.get('/goodbye')
    response.should.be.ok
    response.body.should.equal 'Goodbye World'
  end

  it 'can take multiple definitions of a route' do
    app = mock_app {
      user_agent /Foo/
      get '/foo' do
        'foo'
      end

      get '/foo' do
        'not foo'
      end
    }

    request = Rack::MockRequest.new(app)
    response = request.get('/foo', 'HTTP_USER_AGENT' => 'Foo')
    response.should.be.ok
    response.body.should.equal 'foo'

    request = Rack::MockRequest.new(app)
    response = request.get('/foo')
    response.should.be.ok
    response.body.should.equal 'not foo'
  end
end
