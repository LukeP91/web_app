class Datafixes::AddAgeToAllUsers < Datafix
  def self.up
    User.where(age: nil).each do |user|
      age = Random.new.rand(1..50)
      user.update_attributes(age: age)
    end
  end
end
