class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end

  # update the song class so that it maps instance attributes to table columns
  def self.create_table 
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end 

  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)
    SQL
    # Insert the song into the database
    DB[:conn].execute(sql, self.name, self.album)

    # get the song ID from the database and save it to the Ruby instance 
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # retuen the Ruby instance
    self 
  end 

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end 
end