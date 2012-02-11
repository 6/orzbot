# Helper methods defined here can be accessed in any controller or view in the application

Orzbot.helpers do
  def format_date(datet)
    if datet.nil?
      "[none]"
    else
      datet.strftime("%Y/%m/%d %H:%M")
    end
  end
end
