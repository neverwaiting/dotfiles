return {
	init_options = {
		cache = {
			directory = '/tmp/ccls_cache'
		}
  },

	cmd = { 'ccls' },

	filetypes = { 'c', 'cc', 'cpp', 'objc', 'objcpp', 'cuda' },

	offset_encoding = 'utf-8',

	-- ccls does not support sending a null root directory
	single_file_support = false,
}

