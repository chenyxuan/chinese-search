# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

describe Search do
  fab!(:admin) { Fabricate(:admin) }

  before do
    SearchIndexer.enable
    Jobs.run_immediately!
  end

  describe 'Chinese search' do

    SiteSetting.default_locale = 'zh_CN'
    SiteSetting.min_search_term_length = 1

    it 'finds chinese topic based on title 如何使用图书馆的书' do
      topic = Fabricate(:topic, title: '如何使用图书馆的书')
      post = Fabricate(:post, topic: topic)

      expect(Search.execute('如何使用图书馆的书').posts.first.id).to eq(post.id)
      expect(Search.execute('使用图书馆的书').posts.first.id).to eq(post.id)
      expect(Search.execute('图书馆').posts.first.id).to eq(post.id)
      expect(Search.execute('图书').posts.first.id).to eq(post.id)
      expect(Search.execute('书').posts.first.id).to eq(post.id)
    end
    
    it 'finds chinese topic based on title 生日蛋糕求推荐' do
      topic = Fabricate(:topic, title: '生日蛋糕求推荐')
      post = Fabricate(:post, topic: topic)

      expect(Search.execute('生日蛋糕求推荐').posts.first.id).to eq(post.id)
      expect(Search.execute('生日蛋糕 推荐').posts.first.id).to eq(post.id)
      expect(Search.execute('蛋糕 推荐').posts.first.id).to eq(post.id)
      expect(Search.execute('生日蛋糕').posts.first.id).to eq(post.id)
      expect(Search.execute('生日').posts.first.id).to eq(post.id)
      expect(Search.execute('蛋糕').posts.first.id).to eq(post.id)
      expect(Search.execute('推荐').posts.first.id).to eq(post.id)
    end
    
    it 'finds chinese topic based on title 【反省总结】2020互联网秋招体会 字节+微软+谷歌' do
      topic = Fabricate(:topic, title: '【反省总结】2020互联网秋招体会 字节+微软+谷歌')
      post = Fabricate(:post, topic: topic)
      
      expect(Search.execute('【反省总结】2020互联网秋招体会 字节+微软+谷歌').posts.first.id).to eq(post.id)
      expect(Search.execute('【反省总结】').posts.first.id).to eq(post.id)
      expect(Search.execute('反省总结').posts.first.id).to eq(post.id)
      expect(Search.execute('2020').posts.first.id).to eq(post.id)
      expect(Search.execute('互联网').posts.first.id).to eq(post.id)
      expect(Search.execute('秋招').posts.first.id).to eq(post.id)
      expect(Search.execute('体会').posts.first.id).to eq(post.id)
      expect(Search.execute('字节').posts.first.id).to eq(post.id)
      expect(Search.execute('微软').posts.first.id).to eq(post.id)
      expect(Search.execute('谷歌').posts.first.id).to eq(post.id)
    end
    
    it 'finds chinese topic based on title 拼多多劝退，所有秋招拿了offer的都请三思' do
      topic = Fabricate(:topic, title: '拼多多劝退，所有秋招拿了offer的都请三思')
      post = Fabricate(:post, topic: topic)
      
      expect(Search.execute('拼多多劝退，所有秋招拿了offer的都请三思').posts.first.id).to eq(post.id)
      expect(Search.execute('拼多多 offer').posts.first.id).to eq(post.id)
      expect(Search.execute('拼多多 三思').posts.first.id).to eq(post.id)
      expect(Search.execute('拼多多').posts.first.id).to eq(post.id)
      expect(Search.execute('劝退').posts.first.id).to eq(post.id)
      expect(Search.execute('秋招').posts.first.id).to eq(post.id)
      expect(Search.execute('offer').posts.first.id).to eq(post.id)
    end
    
    
    it 'finds chinese topic based on title 震惊！计算机系专业课优秀作业中竟出现未标出处和 GitHub 上一模一样的代码！' do
      topic = Fabricate(:topic, title: '震惊！计算机系专业课优秀作业中竟出现未标出处和 GitHub 上一模一样的代码！')
      post = Fabricate(:post, topic: topic)
      
      expect(Search.execute('震惊！计算机系专业课优秀作业中竟出现未标出处和 GitHub 上一模一样的代码！').posts.first.id).to eq(post.id)
      expect(Search.execute('计算机系 GitHub 一模一样 代码').posts.first.id).to eq(post.id)
      expect(Search.execute('一模一样 代码').posts.first.id).to eq(post.id)
      expect(Search.execute('优秀作业 未标出处').posts.first.id).to eq(post.id)
      expect(Search.execute('计算机系 专业课').posts.first.id).to eq(post.id)
      expect(Search.execute('未标出处 GitHub').posts.first.id).to eq(post.id)
      expect(Search.execute('优秀作业').posts.first.id).to eq(post.id)
      expect(Search.execute('未标出处').posts.first.id).to eq(post.id)
      expect(Search.execute('GitHub').posts.first.id).to eq(post.id)
      expect(Search.execute('计算机系').posts.first.id).to eq(post.id)
      expect(Search.execute('专业课').posts.first.id).to eq(post.id)
      expect(Search.execute('震惊').posts.first.id).to eq(post.id)
    end
    
    it 'finds chinese topic based on title 同去网究竟是谁在运营？——从差点被校外培训机构割韭菜说起' do
      topic = Fabricate(:topic, title: '同去网究竟是谁在运营？——从差点被校外培训机构割韭菜说起')
      post = Fabricate(:post, topic: topic)
      
      expect(Search.execute('同去网究竟是谁在运营？——从差点被校外培训机构割韭菜说起').posts.first.id).to eq(post.id)
      expect(Search.execute('同去网 校外培训机构 割韭菜').posts.first.id).to eq(post.id)
      expect(Search.execute('差点被校外培训机构割韭菜').posts.first.id).to eq(post.id)
      expect(Search.execute('同去网究竟是谁在运营').posts.first.id).to eq(post.id)
      expect(Search.execute('同去网运营').posts.first.id).to eq(post.id)
      expect(Search.execute('培训机构').posts.first.id).to eq(post.id)
    end
    
    
    it 'finds chinese topic based on title 【连载】奇迹与魔法，可不是免费的哦……——(La)TeX公式不为人知的一面（更新至第2部分）' do
      topic = Fabricate(:topic, title: '【连载】奇迹与魔法，可不是免费的哦……——(La)TeX公式不为人知的一面（更新至第2部分')
      post = Fabricate(:post, topic: topic)
      
      expect(Search.execute('连载】奇迹与魔法，可不是免费的哦……——(La)TeX公式不为人知的一面（更新至第2部分').posts.first.id).to eq(post.id)
      expect(Search.execute('(La)TeX公式不为人知的一面').posts.first.id).to eq(post.id)
      expect(Search.execute('奇迹与魔法不是免费的').posts.first.id).to eq(post.id)
      expect(Search.execute('Tex不为人知的一面').posts.first.id).to eq(post.id)
      expect(Search.execute('Tex 不为人知').posts.first.id).to eq(post.id)
      expect(Search.execute('Tex').posts.first.id).to eq(post.id)
    end
    
    
    it 'finds chinese topic based on title 交大门口永平路七彩花店欺诈，殴打，骚扰学生（9.16中午最新版本）' do
      topic = Fabricate(:topic, title: '交大门口永平路七彩花店欺诈，殴打，骚扰学生（9.16中午最新版本）')
      post = Fabricate(:post, topic: topic)
      
      expect(Search.execute('交大门口永平路七彩花店欺诈，殴打，骚扰学生（9.16中午最新版本）').posts.first.id).to eq(post.id)
      expect(Search.execute('永平路七彩花店 殴打学生').posts.first.id).to eq(post.id)
      expect(Search.execute('交大门口永平路七彩花店').posts.first.id).to eq(post.id)
      expect(Search.execute('七彩花店 最新版本').posts.first.id).to eq(post.id)
      expect(Search.execute('永平路 花店 欺诈').posts.first.id).to eq(post.id)
      expect(Search.execute('花店骚扰学生').posts.first.id).to eq(post.id)
      expect(Search.execute('花店 欺诈').posts.first.id).to eq(post.id)
      expect(Search.execute('花店 9.16').posts.first.id).to eq(post.id)
      expect(Search.execute('花店').posts.first.id).to eq(post.id)
    end
    
    it 'finds chinese topic based on title 我加速超越，却甩不掉紧紧跟随的伤悲' do
      topic = Fabricate(:topic, title: '我加速超越，却甩不掉紧紧跟随的伤悲')
      post = Fabricate(:post, topic: topic)
      
      expect(Search.execute('我加速超越，却甩不掉紧紧跟随的伤悲').posts.first.id).to eq(post.id)
      expect(Search.execute('甩不掉紧紧跟随的伤悲').posts.first.id).to eq(post.id)
      expect(Search.execute('加速超越 甩不掉').posts.first.id).to eq(post.id)
      expect(Search.execute('紧紧跟随 伤悲').posts.first.id).to eq(post.id)
      expect(Search.execute('甩不掉 伤悲').posts.first.id).to eq(post.id)
      expect(Search.execute('超越 伤悲').posts.first.id).to eq(post.id)
      expect(Search.execute('甩不掉').posts.first.id).to eq(post.id)
      expect(Search.execute('伤悲').posts.first.id).to eq(post.id)
      expect(Search.execute('加速').posts.first.id).to eq(post.id)
    end
    
    it 'finds chinese topic based on title 实名赞扬二餐阿姨：“先去买饭不要占座”' do
      topic = Fabricate(:topic, title: '实名赞扬二餐阿姨：“先去买饭不要占座”')
      post = Fabricate(:post, topic: topic)
      
      expect(Search.execute('实名赞扬二餐阿姨：“先去买饭不要占座”').posts.first.id).to eq(post.id)
      expect(Search.execute('赞扬二餐阿姨').posts.first.id).to eq(post.id)
      expect(Search.execute('先去买饭不要占座').posts.first.id).to eq(post.id)
      expect(Search.execute('二餐阿姨').posts.first.id).to eq(post.id)
      expect(Search.execute('不要占座').posts.first.id).to eq(post.id)
      expect(Search.execute('二餐').posts.first.id).to eq(post.id)
      expect(Search.execute('阿姨').posts.first.id).to eq(post.id)
      expect(Search.execute('占座').posts.first.id).to eq(post.id)
    end
  end
end
