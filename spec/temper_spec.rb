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
  it { expect(subject.mode).to eq :auto }
  it { expect(subject.direction).to eq :direct }

  context 'computing data' do
    before do
      controller.control 50.0
    end

    it { expect(subject.output).to eq 50.0 }

    it 'should PID calc it' do
      controller.setpoint = 75.0
      expect(subject.output).to eq 50.0
      controller.control  50.0
      expect(subject.output).to eq 50.0
      controller.control  85.0
      expect(subject.output).to eq 50.0
    end
  end
end
