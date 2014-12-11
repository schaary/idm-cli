# encoding: utf-8

class Account
   attr_accessor :uid, :email, :firstname, :lastname, :date_of_birth, :gender, :end_date, :final_date, :account_type, :state, :academic_grade

  def salutation
    return 'Sehr geehrter Herr' if 1 == @gender
    return 'Sehr geehrte Frau'  if 2 == @gender
    return 'Sehr geehrte(r) Frau/Herr' if 1 != @gender && 2 != @gender
  end

end
