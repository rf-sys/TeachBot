module TeachBot
  class Commands
    include ActiveModel::Validations

    attr_reader :status

    def initialize(request)
      @request = request
      @status = 200
    end

    def generate_response
      if respond_to?("#{@request[:command]}_command")
        send("#{@request[:command]}_command")
      else
        @status = 404
        {command: @request[:command], response: 'Command not found'}
      end
    end


    # available commands
    def help_command
      {command: 'Get help', response: 'Help me!!!1111'}
    end


  end
end