require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "when handling requests" do
  def readBinaryRequest(binary_path)
    File.open(File.dirname(__FILE__) + '/../fixtures/request/' + binary_path).read
  end

  it "should handle remoting message from remote object" do
    input = readBinaryRequest("remotingMessage.bin")
    req = AMF::Request.new.populate_from_stream(input)

    req.headers.length.should == 0
    req.messages.length.should == 1
    message = req.messages[0].data[0]
    message.should be_a(AMF::Values::RemotingMessage)
    message.messageId.should == "FE4AF2BC-DD3C-5470-05D8-9971D51FF89D"
    message.body.should == [true]
  end

  it "should handle command message from remote object" do
    input = readBinaryRequest("commandMessage.bin")
    req = AMF::Request.new.populate_from_stream(input)

    req.headers.length.should == 0
    req.messages.length.should == 1
    message = req.messages[0].data[0]
    message.should be_a(AMF::Values::CommandMessage)
    message.messageId.should == "7B0ACE15-8D57-6AE5-B9D4-99C2D32C8246"
    message.body.should == {}
  end
end

describe "when handling responses" do
  def readBinaryRequest(binary_path)
    File.open(File.dirname(__FILE__) + '/../fixtures/request/' + binary_path).read
  end

  it "should serialize a simple call" do
    resp = AMF::Response.new
    resp.messages << AMF::Message.new('/1/onResult', '', 'hello')

    expected = readBinaryRequest('simple-response.bin')
    resp.serialize.should == expected
  end
end