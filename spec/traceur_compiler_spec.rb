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
		context 'for ECMAScript 6 input with experimental features' do
			let(:source) {
				<<-source
					function foo() {
						var x;
						await x = bar();
					}
				source
			}
			context 'with experimental features enabled' do
				it 'compiles successfully' do
					expect(
						TraceurCompiler.compile(source, :experimental => true)
					).to be_a(String)
				end
			end
			context 'with a specific underscore-style option passed in' do
				it 'compiles successfully' do
					expect(
						TraceurCompiler.compile(source, :deferred_functions => true)
					).to be_a(String)
				end
			end
			context 'with experimental features disabled' do
				it 'throws an exception' do
					expect {
						TraceurCompiler.compile(source, :experimental => false)
					}.to raise_error
				end
			end
			context 'with no options passed in' do
				it 'throws an exception' do
					expect {
						TraceurCompiler.compile(source)
					}.to raise_error
				end
			end
		end
	end
end
