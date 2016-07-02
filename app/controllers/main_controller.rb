class MainController < ApplicationController

  @@directory = "#{Rails.root}/public/"

  def index
  end

  def upload
    if(Share.where(ip: request.remote_ip, created_at: 1.days.ago..DateTime.now).all.count > 5)
      render json: { error: [
        'Cant share more than 5 stats in a day!'
        ]
      }
    else
      name = params[:input].original_filename
      ran_str =  SecureRandom.base64(6).delete('/+=')[0, 6]
      while Share.where(key: ran_str).all.count > 0 do
        ran_str =  SecureRandom.base64(6).delete('/+=')[0, 6]
      end
      path = File.join(@@directory, "#{ran_str}_#{name}")
      File.open(path, "wb") { |f| f.write(params[:input].read) }
      Share.create(key: ran_str, value: name, ip: request.remote_ip)
      render json: { message: [
        'Check your share at <a href=/share/'+ ran_str +'>'+request.env["HTTP_HOST"]+'/share/'+ran_str+'</a>'
        ],
        append: true,
        indicatorTitle: 'Shared'
      }
    end
  end

  def find
    begin
      @share = Share.where(key: params[:key]).take!
      path = File.join(@@directory, "#{@share[:key]}_#{@share[:value]}")
      @file = File.read(path)
    rescue
      redirect_to root_url, :flash => { :danger => "Share not found." }
    end

  end
end
