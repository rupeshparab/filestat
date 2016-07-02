class MainController < ApplicationController

  def index
  end

  def upload
    if(Share.where(ip: request.remote_ip, created_at: 1.days.ago..DateTime.now).all.count > 10000)
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
      params[:input].rewind
      if (params[:input].read.size.to_f / 1048576) > 2
        render json: { error: [
          'File size can\'t be greater than 2MB!'
          ]
        }
      else
        params[:input].rewind
        Share.create(key: ran_str, value: name, ip: request.remote_ip, file_contents: params[:input].read)
        render json: { message: [
          'Check your share at <a href=/share/'+ ran_str +'>'+request.env["HTTP_HOST"]+'/share/'+ran_str+'</a>'
          ]
        }
      end
    end
  end

  def find
    begin
      @share = Share.where(key: params[:key]).take!
    rescue
      redirect_to root_url, :flash => { :danger => "Share not found." }
    end
  end
end
