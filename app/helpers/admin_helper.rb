module AdminHelper
  def users_chart_url
    make_chart(User.find(:all, :order => "created_at ASC"), "Users")
  end

  def sleeps_chart_url
    make_chart(Sleep.find(:all, :order => "created_at ASC"), "Sleeps")
  end

  def make_chart(array,name)
    num_of_users = array.length
    user_array = []
    current_date = Date.civil(y=2009,m=2,d=22)
    current_user = 0
    while current_date <= Date.today+1.days
      while current_user < num_of_users && array[current_user].created_at <= current_date
        current_user += 1
      end
      user_array.push([current_date-1.days,current_user])
      current_date += 1.days
    end    

    day_array = []
    users_array = []
    new_users_array = []
    for user in user_array
      day_array.push(user[0])
      users_array.push(user[1])
      new_users_array.push(user[1])
    end

    puts new_users_array

    for i in 0..new_users_array.length-1
      if i > 0
        new_users_array[i] -= users_array[i-1]
      end
#      new_users_array.push(users)
    end

    puts new_users_array

    if day_array.length > 9
      day_array = [day_array.first, day_array.last]
    end  
    puts user_array
    puts day_array
    day_array = day_array.map {|x| x.strftime("%m/%d")}

    # Line Chart
    GoogleChart::LineChart.new('600x300', "User Growth", false) do |lc|
      lc.data "#{name}", users_array, '0000ff'
      lc.data "New #{name}", new_users_array, 'ff0000'
      lc.show_legend = true
      lc.axis :y, :range => [0,num_of_users], :color => '000000', :font_size => 16, :alignment => :center
      lc.axis :x, :labels => day_array, :color => '000000', :font_size => 16, :alignment => :center
      return lc.to_url
    end
  end
end
