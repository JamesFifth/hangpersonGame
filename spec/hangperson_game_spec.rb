require 'spec_helper'
require 'hangperson_game'

describe HangpersonGame do
    # helper function: make several guesses
    def guess_several_letters(game, letters)
    letters.chars do |letter|
        game.guess(letter)
    end
end

# The describe take a class name and/or string argument and also a block with do and end
describe 'new' do
    it "takes a parameter and returns a HangpersonGame object" do
        # create a new instance ofhangpersonGame
        @hangpersonGame = HangpersonGame.new('glorp')
        # to verify whether @hangpersonGame is an instance of HangpersonGame
        expect(@hangpersonGame).to be_an_instance_of(HangpersonGame)
        # to verify whether @hangpersonGame.word equals to 'glorp'
        expect(@hangpersonGame.word).to eq('glorp')
        # to verify whether @hangpersonGame.guesses equals to ''
        expect(@hangpersonGame.guesses).to eq('')
        # to verify whether @hangpersonGame.wrong_guesses equals to ''
        expect(@hangpersonGame.wrong_guesses).to eq('')
    end
end

describe 'guessing' do # , :pending => true
    # The context encloses tests of a certain type.
    # not mandatory, but good to specificy
    context 'correctly' do
        
#        To make arbitrary code run before and/or after other block part
#        blocks are called in the following order:
#        before :suite == before :suite //
#        before :context == before :all // blocks are run once before all of the examples in a group
#        before :example == before :each // blocks are run before each example
#        after  :example == before :each // blocks are run after each example
#        after  :context == before :all // blocks are run once after all of the examples in a group
#        after  :suite == before :suite
        
        # blocks are run before each example
        before :each do
            @game = HangpersonGame.new('garply')
            @valid = @game.guess('a')
        end
        
        it 'changes correct guess list' do # , :pending => true
            # The expect keyword is used to define an “Expectation” in RSpec.
            # The eql keyword is called a Matcher.
            # to specify what type of condition you are testing to be true (or false).
            expect(@game.guesses).to eq('a')
            expect(@game.wrong_guesses).to eq('')
        end
        
        it 'returns true' do # , :pending => true
            expect(@valid).not_to be false
        end
    end
    
    context 'incorrectly' do
        before :each do
            @game = HangpersonGame.new('garply')
            @valid = @game.guess('z')
        end
        
        it 'changes wrong guess list' do # , :pending => true
            expect(@game.guesses).to eq('')
            expect(@game.wrong_guesses).to eq('z')
        end
        
        it 'returns true' do # , :pending => true
            expect(@valid).not_to be false
        end
    end
    
    context 'same letter repeatedly' do
        before :each do
            @game = HangpersonGame.new('garply')
            guess_several_letters(@game, 'aq')
        end
        it 'does not change correct guess list' do # , :pending => true
            @game.guess('a')
            expect(@game.guesses).to eq('a')
        end
        it 'does not change wrong guess list' do # , :pending => true
            @game.guess('q')
            expect(@game.wrong_guesses).to eq('q')
        end
        it 'returns false' do # , :pending => true
            expect(@game.guess('a')).to be false
            expect(@game.guess('q')).to be false
        end
        it 'is case insensitive' do # , :pending => true
            expect(@game.guess('A')).to be false
            expect(@game.guess('Q')).to be false
            expect(@game.guesses).not_to include('A')
            expect(@game.wrong_guesses).not_to include('Q')
        end
    end
    
    context 'invalid' do
        before :each do
            @game = HangpersonGame.new('foobar')
        end
        it 'throws an error when empty' do# , :pending => true
            expect { @game.guess('') }.to raise_error(ArgumentError)
        end
        it 'throws an error when not a letter' do# , :pending => true
            expect { @game.guess('%') }.to raise_error(ArgumentError)
        end
        it 'throws an error when nil' do# , :pending => true
            expect { @game.guess(nil) }.to raise_error(ArgumentError)
        end
    end
end

# define an “Example Group”: a collection of tests.
describe 'displayed word with guesses' do# , :pending => true
    before :each do
        @game = HangpersonGame.new('banana')
    end
    # for a given set of guesses, what should the word look like?
    @test_cases = {
        'bn' =>  'b-n-n-',
        'def' => '------',
        'ban' => 'banana'
    }
    @test_cases.each_pair do |guesses, displayed|
        it "should be '#{displayed}' when guesses are '#{guesses}'" do
            guess_several_letters(@game, guesses)
            expect(@game.word_with_guesses).to eq(displayed)
        end
    end
end

# define an “Example Group”: a collection of tests.
describe 'game status' do
    before :each do
        @game = HangpersonGame.new('dog')
    end
    it 'should be win when all letters guessed' do# , :pending => true
        guess_several_letters(@game, 'ogd')
        expect(@game.check_win_or_lose).to eq(:win)
    end
    it 'should be lose after 7 incorrect guesses' do# , :pending => true
        guess_several_letters(@game, 'tuvwxyz')
        expect(@game.check_win_or_lose).to eq(:lose)
    end
    it 'should continue play if neither win nor lose' do# , :pending => true
        guess_several_letters(@game, 'do')
        expect(@game.check_win_or_lose).to eq(:play)
    end
end
end
