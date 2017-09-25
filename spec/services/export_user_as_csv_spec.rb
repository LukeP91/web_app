require 'rails_helper'

describe ExportUsersAsCSV do
  it 'generates csv with users' do
    reading = create(:interest, name: 'Reading')
    horse_riding = create(:interest, name: 'Horse Riding')
    user = create(
      :user,
      first_name: 'Joe',
      last_name: 'Doe',
      email: 'joe.doe@example.com',
      gender: 'male',
      age: 34,
      interests: [reading, horse_riding]
    )

    expect(ExportUsersAsCSV.call([user]).result).to eq "Joe,Doe,joe.doe@example.com,male,34,Reading,Horse Riding\n"
  end
end
