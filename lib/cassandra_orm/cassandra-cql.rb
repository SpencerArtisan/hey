module CassandraCQL
  class Result
    def all_hash_rows
      all = []
      fetch_hash{ |row| all << row if row.length > 1 }
      all
    end
  end
end
