def renders_successfully action, opts={}
  get action, opts
  expect( response ).to be_success
end
