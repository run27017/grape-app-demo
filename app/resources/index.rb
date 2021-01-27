module Resources
  class Index < Grape::API
    version 'v1', using: :header, vendor: 'vendor'
    format :json
    # prefix :api # 如果需要访问所有 API 需要前缀的话

    formatter :json, ->(object, env) {
      JSON.pretty_generate(object, indent: '  ', space: ' ')
    }

    error_formatter :json, ->(error, backtrace, options, env, original_exception) {
      JSON.pretty_generate(error, indent: '  ', space: ' ')
    }

    before do
      set_current_user if headers.key?('X-Token')
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      message = "Couldn't find #{e.model} with '#{e.primary_key}'=#{e.id}"
      error!({ code: 'resource_not_found', message: message }, 404)
    end

    rescue_from Pundit::NotAuthorizedError do |e|
      message = "You are not allowed to #{e.query} originated from #{e.policy.class}"
      error!({ code: 'not_authorized', message: message }, 403)
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      detail = e.errors.map do |names, errors|
        errors = errors.map(&:to_s)
        [names.join(','), errors]
      end.to_h
      error!({ code: 'parameter_invalid', message: 'Some parameters are invalid', detail: detail }, 400)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error!({
        code: 'resource_invalid',
        message: 'Resource validations failed',
        detail: e.record.errors.messages
      }, 422)
    end

    rescue_from :all do |e|
      STDERR.puts "#{e.class}:#{e.message}"
      e.backtrace.each { |line| STDERR.puts("  #{line}")}

      error!({ code: 'unknonw_error', message: '发生了未知错误' }, 500)
    end unless ENV['RACK_ENV'] == 'test'

    helpers do
      include Pundit

      def set_current_user
        @_current_user = User.from_token(headers['X-Token'])
      rescue Token::Errors::Invalid
        @error = { 'code': 'token_invalid', message: 'token 格式异常' }
        render json: @error, status: 400
      end

      def current_user
        @_current_user
      end
    end

    desc 'App description', hidden: true
    get do
      return {
        app_name: 'App Demo'
      }
    end

    # mount 语句一定要放在最后
    mount Resources::Users
    mount Resources::Posts
    mount Resources::Logins

    add_swagger_documentation \
      info: { title: 'App Demo API' }

    route :any, '*path' do
      error!({ code: 'route_not_found', message: '访问的路径不存在' }, 404)
    end
  end
end
