require 'spec_helper'

class Part
 include Mongoid::Document

 field :name, type: String
 belongs_to :piece
  index({name: 1}, background: true)
  index({piece_id: 1}, background: true)
end

class Piece
 include Mongoid::Document

 field :name, type: String
 has_many :parts, class_name: 'Part', validate: false

  index({name: 1}, background: true)
end

describe "calling destroy on belongs_to:" do
  let!(:a_piece) { Piece.create(name: "Main") }
  let!(:part_a) { a_piece.parts.create(name: "part-a") }
  #let!(:part_a) { Part.create(name: "part-a", piece_id: a_piece._id) }

  it "deletes Part from the has_many field of Piece" do
    puts part_a.serializable_hash
    puts a_piece.serializable_hash

    a_piece.parts.each do |part|
      puts "part before_destroy:#{part.serializable_hash}"
    end
    expect(a_piece.parts.any?).to eq(true)
    expect(a_piece.parts.count).to eq(1)

    part_a.destroy!
    #a_piece.parts.last.destroy
    #a_piece.reload

    #a_piece.parts.each do |part|
      #puts "part after_destroy:#{part.serializable_hash}"
    #end
    expect(a_piece.parts.any?).to eq(false)
    expect(a_piece.parts.count).to eq(0)
  
  end
end
