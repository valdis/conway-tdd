# frozen_string_literal: true

require 'rspec'
require_relative './game'

RSpec.describe Cell do
  context 'when a cell is new' do
    it 'is dead' do
      expect(subject.alive?).to eq(false)
    end
  end

  context 'when the cell has 4 neighbrours' do
    let(:neighbours) { Array.new(4) { Cell.new } }

    it 'knows when all neighbours are dead' do
      subject.add_neighbours(neighbours)

      expect(subject.living_neighbour_count).to eq(0)
    end

    it 'knows how many neighbours are alive' do
      # let's rise two neighbours from the dead
      neighbours[0].alive = true
      neighbours[1].alive = true
      subject.add_neighbours(neighbours)

      expect(subject.living_neighbour_count).to eq(2)
    end
  end

  context 'when time takes a step' do
    let(:neighbours) { Array.new(4) { Cell.new } }

    context 'the cell is alive' do
      subject { Cell.new(alive: true) }

      it 'will die if it has less than 2 live neighbours' do
        subject.add_neighbours(neighbours)

        subject.tick

        expect(subject.alive?).to eq(false)
      end

      it 'will die if it has more than 3 live neighbours' do
        0.upto(3) { |idx| neighbours[idx].alive = true }
        subject.add_neighbours(neighbours)

        subject.tick

        expect(subject.alive?).to eq(false)
      end

      it 'will stay alive if it has 2 neighbours' do
        0.upto(1) { |idx| neighbours[idx].alive = true }
        subject.add_neighbours(neighbours)

        subject.tick

        expect(subject.alive?).to eq(true)
      end

      it 'will stay alive if it has 3 neighbours' do
        0.upto(2) { |idx| neighbours[idx].alive = true }
        subject.add_neighbours(neighbours)

        subject.tick

        expect(subject.alive?).to eq(true)
      end

      it 'will stay alive if the last 3 added neighbours are alive' do
        1.upto(3) { |idx| neighbours[idx].alive = true }
        subject.add_neighbours(neighbours)

        subject.tick

        expect(subject.alive?).to eq(true)
      end
    end

    context 'the cell is dead' do
      subject { Cell.new(alive: false) }

      it 'stays dead if there are less than 3 neighbours' do
        1.upto(2) { |idx| neighbours[idx].alive = true }
        subject.add_neighbours(neighbours)

        subject.tick

        expect(subject.alive?).to eq(false)
      end

      it 'should become alive if has 3 live neighbours' do
        1.upto(3) { |idx| neighbours[idx].alive = true }
        subject.add_neighbours(neighbours)

        subject.tick

        expect(subject.alive?).to eq(true)
      end

      it 'stays dead if there are more than 3 neighbours' do
        0.upto(3) { |idx| neighbours[idx].alive = true }
        subject.add_neighbours(neighbours)

        subject.tick

        expect(subject.alive?).to eq(false)
      end
    end
  end
end

RSpec.describe Game do
  context 'when initialising the board' do
    subject { Game.new([[Cell.new(alive: false)]]) }
    it 'can tell if the cell at coordinates x:0, y:0 is alive' do
      expect(subject.cell_alive?(x: 0, y: 0)).to be(false)
    end

    context 'when cells get acquinted with their neigbours' do
      subject do
        Game.new(
          [
            [Cell.new(alive: false), Cell.new(alive: false), Cell.new(alive: false)],
            [Cell.new(alive: false), Cell.new(alive: false), Cell.new(alive: false)],
            [Cell.new(alive: false), Cell.new(alive: false), Cell.new(alive: false)]
          ]
        )
      end

      it 'tells that the 0:0 cell has neighbours 1:0, 0:1 and 1:1' do
        expect(subject.cell_at(x: 0, y: 0).neighbours).to include(
          subject.cell_at(x: 1, y: 0),
          subject.cell_at(x: 0, y: 1),
          subject.cell_at(x: 1, y: 1)
        )
      end
    end
  end
end
