require_relative "../config/environment.rb"
require 'pry'
class Student
  attr_accessor :name, :grade, :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  @@all = []
  def initialize (name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students")
    @@all = []
  end

  def save
      if self.id != nil
        sql = <<-SQL
        UPDATE students
        SET name = ?, grade = ?
        WHERE id = ?
        SQL
        DB[:conn].execute(sql, self.name, self.grade, self.id)
        # @@all.each do |row|
        #   if row.id == self.id
        #     row.name = self.name
        #     row.grade = self.grade
        #   end
      # end
        # binding.pry
      else
        sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
        SQL
        DB[:conn].execute(sql, self.name, self.grade)
        self.id = DB[:conn].get_first_value("SELECT id FROM students WHERE name = ?", self.name)
        # binding.pry
        @@all << self
        end
    self
  end

  def self.create(name, grade)
    x = Student.new(name, grade)
    x.save
  end

  def self.new_from_db(row)
    x = Student.new(row[1], row[2], row[0])
  end

  def self.find_by_name (name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    SQL
    key = DB[:conn].get_first_row(sql, name)
    @@all.find do |student|
      if student.name == name
        student
      end
    end
  end

  def update
    sql = <<-SQL
    UPDATE students
    SET name = ?, grade = ?
    WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
    # binding.pry
    end



end
