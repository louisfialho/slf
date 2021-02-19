def extract_url(url)
  if url.to_s.downcase.include? "http"
    url = URI.extract(url.to_s.downcase, ['http', 'https']).first
  end
end

p extract_url('iadopi https://www.youtube.com/watch?v=hi6g-tHNF4Y&ab_channel=HusseinNasser https://www.youtube.com/watch?v=hi6g-tHNF4Y&ab_channel=HusseinNasser izepodi')
