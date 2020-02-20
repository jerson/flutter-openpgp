Pod::Spec.new do |s|  
    s.name              = 'FastOpenpgp'
    s.version           = '0.4.0'
    s.summary           = 'Openpgp native'
    s.homepage          = 'https://github.com/jerson/openpgp-mobile'

    s.author            = { 'Name' => 'me@jerson.dev' }
    s.license           = { :type => 'MIT' }

    s.platform          = :ios
    s.source            = { :http => 'https://github.com/jerson/openpgp-mobile' }

    s.ios.deployment_target = '8.0'
    s.ios.vendored_frameworks = 'Openpgp.framework'
end  
