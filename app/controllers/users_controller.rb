class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  @@conn = Bunny.new
  @@conn.start
  @@ch = @@conn.create_channel
  @@q = @@ch.queue("sign_up")
  @@q2 = @@ch.queue("table")
  @@q3 = @@ch.queue("users")
  def index

  end

  def show
    @@ch.default_exchange.publish('GIVE ME FCKING USERS!!!', :routing_key => @@q2.name)
    p 'MESSAGE SENT'
    begin
      puts " [*] Waiting for messages. To exit press CTRL+C"
      @@q3.subscribe(:block => true) do |delivery_info, properties, body|
        p body
        @users = JSON.parse body
        @users.each {|user| p user['email']; p user['password']}

        @@conn.close

      end
    rescue Interrupt => _
      conn.close
      exit(0)
     end


    render 'users/show', :locals => { :users => @users }
  end

  def sign_up
    user_form = { email: params[:email], password: params[:password]}
    p user_form
    @@ch.default_exchange.publish(user_form.to_json, :routing_key => @@q.name)
  end

  def sign_ip

  end
end
