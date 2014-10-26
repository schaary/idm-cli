
module IdmCLI
  class Physik < Thor
    desc "adduser", "Adds a new user to the ldap directory of physik department"
    long_desc <<-LONGDESC
      Adds a remote ...
    LONGDESC
    option :uid, required: true
    def adduser
      # implement git remote add
    end

    option :uid, required: true
    desc "deluser", "Rename the remote named <old> to <new>"
    def remove
    end
  end
end
