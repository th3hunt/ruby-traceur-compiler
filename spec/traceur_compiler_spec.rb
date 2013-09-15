require 'traceur_compiler'

describe TraceurCompiler do
	describe '#compile' do
		context 'for valid ECMAScript 6 input' do
			it 'returns valid JavaScript' do
				expect(
					TraceurCompiler.compile('var [a, b] = x;')
				).to eq("var $__0 = x, a = $__0[0], b = $__0[1];\n")
			end
		end
		context 'for invalid ECMAScript 6 input' do
			it 'throws an exception' do
				expect {
					TraceurCompiler.compile('invalid ECMAScript 6')
				}.to raise_error
			end
		end
	end
end
