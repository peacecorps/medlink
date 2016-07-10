class ClassifierForm
  def initialize classifier=nil
    @classifier = classifier || SMS::ReceiptRecorder::Classifier.new
  end

  def model_name
    @classifier.class.name
  end

  def affirmatives
    @affirmatives ||= @classifier.affirmations.to_a.sort.join "\n"
  end

  def negatives
    @negatives ||= @classifier.negations.to_a.sort.join "\n"
  end

  def update affirmations:, negations:
    @classifier.affirmative! affirmations.split("\n")
    @classifier.negative!    negations.split("\n")
  end
end
