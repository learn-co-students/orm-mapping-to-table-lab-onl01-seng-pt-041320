require_relative "../config/environment.rb"

class Student
  DB = {:conn => SQLite3::Database.new("db/students.db")}
  
  attr_accessor :name, :grade 
  attr_reader :id

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    # sql variable
    sql = 
    # beginning of heredoc 
    <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade INTEGER
        )
        SQL
        # end of heredoc
        DB[:conn].execute(sql) 
  end

  def self.drop_table
  sql = <<-SQL
  DROP TABLE students
  SQL

  DB[:conn].execute(sql)
  end

  def save 
    # saves attributes the students database
    sql = <<-SQL
    INSERT INTO students (name, grade)
     VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
   
  def self.create(name:, grade:)
    student = self.new(name, grade)
    student.save
    student
  end
end
