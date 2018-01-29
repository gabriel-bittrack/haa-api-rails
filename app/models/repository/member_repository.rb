module Repository
  class MemberRepository
    def self.count
      Member.all.count
    end
  end
end
