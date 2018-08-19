require 'spec_helper'

describe Temper::PID do
  let(:controller) { Temper::PID.new }

  before do
    controller.setpoint = 100.0
    controller.tune 1.0, 1.0, 1.0
  end
  subject { controller }

  it { expect(subject.kp).to eq 1.0 }
  it { expect(subject.ki).to eq 1.0 }
  it { expect(subject.kd).to eq 1.0 }
  it { expect(subject.pom).to be_falsey }
  it { expect(subject.mode).to eq :auto }
  it { expect(subject.direction).to eq :direct }

  context 'reverse' do
    before do
      controller.direction = :reverse
      controller.tune 1.0, 1.0, 1.0
    end
    subject { controller }

    it { expect(subject.kp).to eq(-1.0) }
    it { expect(subject.ki).to eq(-1.0) }
    it { expect(subject.kd).to eq(-1.0) }
    it { expect(subject.mode).to eq :auto }
    it { expect(subject.direction).to eq :reverse }
  end

  # TODO..Mock Time?
  context 'computing data PoE' do
    before do
      controller.control 50.0
    end

    it { expect(subject.output).to eq 50.0 }
    it { expect(subject.pom).to be_falsey }

    it 'should calc it' do
      controller.setpoint = 75.0
      expect(subject.output).to eq 50.0
      sleep 1
      controller.control 50.0
      expect(subject.output).to eq 100.0
      sleep 1
      controller.control 85.0
      expect(subject.output).to eq 20.0
    end
  end

  context 'computing data PoM' do
    before do
      controller.control 50.0
      controller.pom = true
    end

    it { expect(subject.output).to eq 50.0 }
    it { expect(subject.pom).to be_truthy }

    it 'should calc it' do
      controller.setpoint = 75.0
      expect(subject.output).to eq 50.0
      sleep 1
      controller.control 50.0
      expect(subject.output).to eq 75.0
      sleep 1
      controller.control 72.0
      expect(subject.output).to eq 34.0
    end
  end
end
