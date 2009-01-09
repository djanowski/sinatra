require 'test/spec'
require 'sinatra/base'
require 'sinatra/test'

describe 'Sinatra' do
  it 'creates a new Sinatra::Stage subclass on new' do
    app =
      Sinatra.new do
        get '/' do
          'Hello World'
        end
      end
    app.superclass.should.be Sinatra::Stage
  end
end
