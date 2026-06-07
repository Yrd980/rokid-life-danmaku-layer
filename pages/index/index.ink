<script def>
{
  "navigationBarTitleText": "Life Danmaku",
  "description": "A Rokid Glass AIUI HUD for remote AIUI voice command controls, AI persona danmaku, memory-aware comments, NPC profiles, daily recap, and safety controls.",
  "schema": {
    "data": {
      "type": "object",
      "properties": {
        "initialScene": {
          "type": "string",
          "enum": ["street", "cafe", "office", "gym", "store", "subway"]
        },
        "liveScene": {
          "type": "object",
          "description": "Live AI scene understanding result from Rokid/AIUI. Use this when the glasses already understand the current environment.",
          "properties": {
            "id": { "type": "string" },
            "name": { "type": "string" },
            "confidence": { "type": "string" },
            "signal": { "type": "string" },
            "scan": { "type": "string" },
            "summary": { "type": "string" }
          }
        },
        "sceneUnderstanding": {
          "type": "object",
          "description": "Alias of liveScene for Live AI scene understanding payloads.",
          "properties": {
            "id": { "type": "string" },
            "name": { "type": "string" },
            "confidence": { "type": "string" },
            "signal": { "type": "string" },
            "scan": { "type": "string" },
            "summary": { "type": "string" }
          }
        }
      }
    }
  }
}
</script>

<script setup>

const SCENES = [
  { id: 'street', name: '街道', confidence: '92%', signal: '路过 Blue Bottle 第 17 次', scan: 'OPEN WORLD' },
  { id: 'cafe', name: '咖啡店', confidence: '89%', signal: '冰美式习惯识别', scan: 'CAFFEINE' },
  { id: 'office', name: '办公室', confidence: '94%', signal: '文档凝视 12 分钟', scan: 'KPI WATCH' },
  { id: 'gym', name: '健身房', confidence: '87%', signal: '惯性对抗中', scan: 'BODY QUEST' },
  { id: 'store', name: '便利店', confidence: '91%', signal: '甜品区自动导航', scan: 'SNACK LOOP' },
  { id: 'subway', name: '地铁', confidence: '85%', signal: '社交电量保护', scan: 'LOW POWER' }
];

const DEFAULT_LIVE_SCENE = {
  id: 'live',
  name: '眼前环境',
  confidence: 'LIVE',
  signal: '等待 AIUI 场景理解输入',
  scan: 'WORLD VIEW'
};

const DEFAULT_SCENE_ID = 'street';

const SCENE_ALIASES = [
  { id: 'street', keys: ['street', 'road', '街道', '路上', '马路', '户外'] },
  { id: 'cafe', keys: ['cafe', 'coffee', '咖啡', '咖啡店'] },
  { id: 'office', keys: ['office', 'work', '办公室', '工位', '会议室', '工作'] },
  { id: 'gym', keys: ['gym', '健身', '健身房', '运动'] },
  { id: 'store', keys: ['store', 'shop', '便利店', '商店', '超市'] },
  { id: 'subway', keys: ['subway', 'metro', '地铁', '通勤', '车厢'] }
];

const PERSONAS = [
  {
    id: 'friend',
    name: '毒舌朋友',
    avatar: 'F',
    tone: '犀利幽默',
    description: '嘴欠但不伤人，负责制造截图传播感。',
    example: '你俩到底谁先表白？',
    enabled: true,
    strength: 3
  },
  {
    id: 'therapist',
    name: '温柔咨询师',
    avatar: 'T',
    tone: '温和洞察',
    description: '降低压力，给情绪一个缓冲层。',
    example: '你是需要慢下来的理由。',
    enabled: true,
    strength: 2
  },
  {
    id: 'kid',
    name: '10 岁的你',
    avatar: 'K',
    tone: '天真直接',
    description: '提醒初心，也偶尔扎心。',
    example: '小时候的你不是这么计划的。',
    enabled: true,
    strength: 2
  },
  {
    id: 'cat',
    name: '你的猫',
    avatar: 'C',
    tone: '高冷懒散',
    description: '像一只旁观你生活的冷静生物。',
    example: '人类真奇怪。',
    enabled: true,
    strength: 1
  },
  {
    id: 'mentor',
    name: '创业导师',
    avatar: 'M',
    tone: '战略效率',
    description: '把人生翻译成任务面板。',
    example: '实际生产力提升待观察。',
    enabled: true,
    strength: 2
  },
  {
    id: 'parallel',
    name: '平行宇宙的你',
    avatar: 'P',
    tone: '神秘遗憾',
    description: '负责人生假设线和情绪留存。',
    example: '另一个宇宙里的你进去了。',
    enabled: true,
    strength: 2
  }
];

const DANMAKU = [
  {
    id: 'street-1',
    scene: 'street',
    persona: 'friend',
    text: '你已经路过这家店 17 次了，你俩到底谁先表白？',
    tone: 'sharp',
    toneLabel: '吐槽',
    intensity: 1,
    memoryReference: 'Blue Bottle 路过 17 次，进入 2 次',
    reason: '系统识别到你连续多次靠近店门又绕开。',
    safetyLevel: 'safe'
  },
  {
    id: 'street-2',
    scene: 'street',
    persona: 'kid',
    text: '小时候的你以为长大后会很酷，现在主要是在找便宜咖啡。',
    tone: 'nostalgic',
    toneLabel: '童年线',
    intensity: 2,
    memoryReference: '你最近 9 天都搜索了咖啡优惠',
    reason: '来自长期消费和路线记忆，不评价身体或收入。',
    safetyLevel: 'safe'
  },
  {
    id: 'street-3',
    scene: 'street',
    persona: 'cat',
    text: '你走路目的性很强，实际上只是怕停下来显得迷茫。',
    tone: 'funny',
    toneLabel: '冷眼',
    intensity: 2,
    memoryReference: '压力日平均步速更快',
    reason: '步速和停留点变化像是在逃避等待。',
    safetyLevel: 'safe'
  },
  {
    id: 'street-4',
    scene: 'street',
    persona: 'parallel',
    text: '另一个宇宙里的你已经进去了，并且点了最贵的那杯。',
    tone: 'nostalgic',
    toneLabel: '支线',
    intensity: 3,
    memoryReference: '反复路过但没进去的店排行第 1',
    reason: '把未发生选择做成轻量人生支线。',
    safetyLevel: 'safe'
  },
  {
    id: 'cafe-1',
    scene: 'cafe',
    persona: 'mentor',
    text: '咖啡因摄入 +1，实际生产力提升待观察。',
    tone: 'strategic',
    toneLabel: 'KPI',
    intensity: 1,
    memoryReference: '压力大时冰美式概率 73%',
    reason: '咖啡购买频率和待办完成时间没有稳定正相关。',
    safetyLevel: 'safe'
  },
  {
    id: 'cafe-2',
    scene: 'cafe',
    persona: 'friend',
    text: '你点冰美式的熟练程度，像是在续命而不是消费。',
    tone: 'sharp',
    toneLabel: '吐槽',
    intensity: 2,
    memoryReference: '本周冰美式 4 杯',
    reason: '识别到你进店后几乎没有菜单犹豫。',
    safetyLevel: 'safe'
  },
  {
    id: 'cafe-3',
    scene: 'cafe',
    persona: 'therapist',
    text: '你不是需要咖啡，你是需要一个可以慢下来的理由。',
    tone: 'warm',
    toneLabel: '安抚',
    intensity: 1,
    memoryReference: '周一上午情绪通常偏低',
    reason: '在低电量时段给出低压力解释。',
    safetyLevel: 'safe'
  },
  {
    id: 'cafe-4',
    scene: 'cafe',
    persona: 'cat',
    text: '这杯水有苦味。人类真奇怪。',
    tone: 'funny',
    toneLabel: '陪伴',
    intensity: 3,
    memoryReference: '个人梗：苦味水',
    reason: '命中了你收藏过的猫式吐槽风格。',
    safetyLevel: 'safe'
  },
  {
    id: 'office-1',
    scene: 'office',
    persona: 'friend',
    text: '你打开文档 12 分钟了，目前贡献是改了标题大小。',
    tone: 'sharp',
    toneLabel: '效率',
    intensity: 1,
    memoryReference: '文档启动后 15 分钟内常改格式',
    reason: '观察到重复格式调整，未进入正文编辑。',
    safetyLevel: 'safe'
  },
  {
    id: 'office-2',
    scene: 'office',
    persona: 'mentor',
    text: '当前 KPI：假装忙碌完成度 87%。',
    tone: 'strategic',
    toneLabel: '任务化',
    intensity: 2,
    memoryReference: '会议前 20 分钟高频切窗口',
    reason: '用游戏指标表达轻度拖延，不进行人格评价。',
    safetyLevel: 'safe'
  },
  {
    id: 'office-3',
    scene: 'office',
    persona: 'kid',
    text: '你小时候说想当科学家，不是想当表格管理员。',
    tone: 'nostalgic',
    toneLabel: '初心',
    intensity: 3,
    memoryReference: '童年愿望：科学家',
    reason: '把当前任务和旧记忆形成反差。',
    safetyLevel: 'safe'
  },
  {
    id: 'office-4',
    scene: 'office',
    persona: 'therapist',
    text: '你现在的焦虑，也许不是事情太多，是不知道先做哪一个。',
    tone: 'warm',
    toneLabel: '观察',
    intensity: 1,
    memoryReference: '任务列表超过 8 条时完成率下降',
    reason: '工作模式下保留提醒，减少吐槽。',
    safetyLevel: 'safe'
  },
  {
    id: 'gym-1',
    scene: 'gym',
    persona: 'friend',
    text: '你看跑步机的眼神，像在看前任朋友圈。',
    tone: 'funny',
    toneLabel: '吐槽',
    intensity: 2,
    memoryReference: '跑步机观察 4 分钟，启动 0 次',
    reason: '只吐槽犹豫行为，不攻击身体。',
    safetyLevel: 'safe'
  },
  {
    id: 'gym-2',
    scene: 'gym',
    persona: 'mentor',
    text: '身体资产维护任务已启动。',
    tone: 'strategic',
    toneLabel: '任务',
    intensity: 1,
    memoryReference: '连续 9 天说今天开始',
    reason: '把进入健身房本身记为行动进展。',
    safetyLevel: 'safe'
  },
  {
    id: 'gym-3',
    scene: 'gym',
    persona: 'therapist',
    text: '今天来这里，本身就已经赢过了昨天的惯性。',
    tone: 'warm',
    toneLabel: '鼓励',
    intensity: 1,
    memoryReference: '上次健身记录 11 天前',
    reason: '饮食和身材保护开启，不输出羞辱性评论。',
    safetyLevel: 'safe'
  },
  {
    id: 'gym-4',
    scene: 'gym',
    persona: 'cat',
    text: '为什么人类要主动制造疲惫？无法理解。',
    tone: 'funny',
    toneLabel: '冷眼',
    intensity: 3,
    memoryReference: '猫人格收藏率高',
    reason: '用非攻击性视角制造轻松陪伴感。',
    safetyLevel: 'safe'
  },
  {
    id: 'store-1',
    scene: 'store',
    persona: 'friend',
    text: '你说只是进来看看，但手已经自动导航到甜品区。',
    tone: 'funny',
    toneLabel: '便利店',
    intensity: 1,
    memoryReference: '便利店甜品区停留率 68%',
    reason: '描述行为路径，不评价饮食选择。',
    safetyLevel: 'safe'
  },
  {
    id: 'store-2',
    scene: 'store',
    persona: 'parallel',
    text: '另一个宇宙里你买了沙拉，但那个宇宙目前观测不到。',
    tone: 'nostalgic',
    toneLabel: '支线',
    intensity: 2,
    memoryReference: '个人梗：观测不到',
    reason: '用假设人生线制造幽默，不制造焦虑。',
    safetyLevel: 'safe'
  },
  {
    id: 'store-3',
    scene: 'store',
    persona: 'cat',
    text: '关东煮闻起来像热闹的人类汤。',
    tone: 'funny',
    toneLabel: '嗅觉',
    intensity: 3,
    memoryReference: '去年冬天收藏过关东煮弹幕',
    reason: '场景气味触发了旧弹幕梗。',
    safetyLevel: 'safe'
  },
  {
    id: 'store-4',
    scene: 'store',
    persona: 'therapist',
    text: '有时候一份小食物，是在给辛苦的一天收尾。',
    tone: 'warm',
    toneLabel: '安抚',
    intensity: 1,
    memoryReference: '加班后便利店停留变多',
    reason: '饮食保护下，只提供情绪解释。',
    safetyLevel: 'safe'
  },
  {
    id: 'subway-1',
    scene: 'subway',
    persona: 'therapist',
    text: '你现在像手机省电模式，能不社交就先别强撑。',
    tone: 'warm',
    toneLabel: '低电量',
    intensity: 1,
    memoryReference: '通勤后社交回复延迟更长',
    reason: '识别到通勤和低社交电量模式。',
    safetyLevel: 'safe'
  },
  {
    id: 'subway-2',
    scene: 'subway',
    persona: 'friend',
    text: '你站得像很有方向感，其实只是在等人群替你决定出口。',
    tone: 'funny',
    toneLabel: '通勤',
    intensity: 2,
    memoryReference: '同站口犹豫 5 次',
    reason: '来自动线记忆，不评价陌生人。',
    safetyLevel: 'safe'
  },
  {
    id: 'subway-3',
    scene: 'subway',
    persona: 'parallel',
    text: '另一个宇宙的你坐过站了，但那条线意外很美。',
    tone: 'nostalgic',
    toneLabel: '误差',
    intensity: 3,
    memoryReference: '上月坐过站 2 次',
    reason: '把小失误处理成柔和叙事。',
    safetyLevel: 'safe'
  }
];

const NPCS = [
  {
    id: 'wang',
    name: '小王',
    role: '同事 NPC',
    level: 'Lv.12',
    familiarity: '76',
    trust: '63',
    lastSeen: '3 天前',
    status: '稳定但略显塑料',
    hidden: '会议中喜欢抢最后一句',
    keywords: '哈哈哈、周报、改天',
    advice: '不要和他讨论周报格式，会陷入无限循环。',
    roast: '关系像共享文档：都在编辑，但没人敢点最终版。'
  },
  {
    id: 'emily',
    name: 'Emily',
    role: '朋友 NPC',
    level: 'Lv.18',
    familiarity: '88',
    trust: '79',
    lastSeen: '昨天',
    status: '高频约饭，低频成行',
    hidden: '把改天当成时间单位',
    keywords: '改天、咖啡、真的要见',
    advice: '直接给两个时间选项，不要再说有空约。',
    roast: '你们的友谊不是淡了，是被日历缓存了。'
  }
];

const MEMORY_ITEMS = [
  { id: 'm1', type: '地点', title: 'Blue Bottle', detail: '路过 17 次，只进去 2 次', weight: '高频' },
  { id: 'm2', type: '习惯', title: '压力冰美式', detail: '压力大时冰美式概率 73%', weight: '稳定' },
  { id: 'm3', type: '人物', title: 'Emily', detail: '聊天高频词是“改天”', weight: '社交' },
  { id: 'm4', type: '情绪', title: '周一上午', detail: '情绪通常偏低，需要低压力提醒', weight: '模式' },
  { id: 'm5', type: '行为', title: '明天健身', detail: '连续 9 天说“明天开始”', weight: '循环' },
  { id: 'm6', type: '个人梗', title: '观测不到宇宙', detail: '常用于温和吐槽未发生选择', weight: '梗' }
];

const RECAP_ITEMS = [
  { id: 'r1', label: '标题', value: '昨天的你：在努力和摆烂之间反复横跳' },
  { id: 'r2', label: '最佳弹幕', value: '你在便利店门口犹豫 23 秒，人生重大决策 +1' },
  { id: 'r3', label: '最尴尬瞬间', value: '向同事说“我马上发”，然后先整理了桌面' },
  { id: 'r4', label: '情绪曲线', value: '上午低电量，下午假装高效，晚上精神复活' },
  { id: 'r5', label: '关键词', value: '拖延、咖啡、社交电量不足、嘴硬' },
  { id: 'r6', label: '今日建议', value: '把第一件事做小一点，先赢 15 分钟' }
];

const SAFETY_ITEMS = [
  { id: 'datingMode', title: '约会模式', detail: '减少毒舌，增加温柔观察', enabled: false },
  { id: 'workMode', title: '工作模式', detail: '只保留提醒，不做吐槽', enabled: false },
  { id: 'lowMoodMode', title: '情绪低落模式', detail: '自动降低负面弹幕', enabled: true },
  { id: 'sensitiveMute', title: '敏感场景静默', detail: '医院、面试、争吵等自动静音', enabled: true },
  { id: 'foodProtection', title: '饮食保护', detail: '禁止身材和饮食羞辱', enabled: true },
  { id: 'socialProtection', title: '社交保护', detail: '不评价外貌、身份和收入', enabled: true }
];

const TAB_SEQUENCE = ['live', 'persona', 'npc', 'memory', 'recap', 'safety'];

function findById(list, id) {
  for (let i = 0; i < list.length; i += 1) {
    if (list[i].id === id) {
      return list[i];
    }
  }
  return list[0];
}

function findExactById(list, id) {
  for (let i = 0; i < list.length; i += 1) {
    if (list[i].id === id) {
      return list[i];
    }
  }
  return null;
}

function parseMaybeJson(value) {
  if (!value || typeof value !== 'string') {
    return value;
  }
  try {
    return JSON.parse(value);
  } catch (error) {
    return value;
  }
}

function resolveSceneId(input) {
  const value = String(input || '').toLowerCase();
  for (let i = 0; i < SCENE_ALIASES.length; i += 1) {
    const alias = SCENE_ALIASES[i];
    for (let j = 0; j < alias.keys.length; j += 1) {
      if (value.indexOf(alias.keys[j].toLowerCase()) >= 0) {
        return alias.id;
      }
    }
  }
  return '';
}

function normalizeLiveScene(input) {
  const data = parseMaybeJson(input);
  if (!data || typeof data !== 'object') {
    return null;
  }
  const textForMatch = [
    data.id,
    data.sceneId,
    data.type,
    data.name,
    data.sceneName,
    data.title,
    data.signal,
    data.summary
  ].join(' ');
  const mappedId = resolveSceneId(textForMatch);
  const id = mappedId || data.id || data.sceneId || 'live';
  const known = findExactById(SCENES, id);
  const name = data.name || data.sceneName || data.title || (known && known.name) || '实时场景';
  const confidence = data.confidence || data.score || (known && known.confidence) || 'LIVE';
  const signal = data.signal || data.summary || data.description || (known && known.signal) || 'Live AI 已理解当前环境';
  const scan = data.scan || data.category || data.intent || (known && known.scan) || 'LIVE AI';
  return {
    id,
    name,
    confidence: String(confidence),
    signal,
    scan
  };
}

function getPersonaName(id) {
  const persona = findById(PERSONAS, id);
  return persona ? persona.name : id;
}

function getPersonaAvatar(id) {
  const persona = findById(PERSONAS, id);
  return persona ? persona.avatar : '?';
}

function allDanmakuItems(generatedItems) {
  return (generatedItems || []).concat(DANMAKU);
}

function buildDanmakuView(sceneId, personas, intensity, silentMode, paused, selectedId, favoriteIds, generatedItems) {
  if (paused) {
    return [];
  }

  const maxCount = silentMode ? 1 : intensity === 1 ? 1 : 3;
  const visible = [];
  const source = allDanmakuItems(generatedItems);
  for (let i = 0; i < source.length; i += 1) {
    const item = source[i];
    const persona = findById(personas, item.persona);
    if (
      item.scene === sceneId &&
      persona &&
      persona.enabled &&
      item.intensity <= intensity &&
      item.intensity <= persona.strength &&
      item.safetyLevel === 'safe' &&
      (!selectedId || item.id === selectedId)
    ) {
      visible.push({
        ...item,
        personaName: persona.name,
        avatar: persona.avatar,
        laneClass: `lane-${visible.length % 3}`,
        speedClass: `speed-${(visible.length % 3) + 1}`,
        selected: item.id === selectedId,
        favorited: favoriteIds.indexOf(item.id) >= 0,
        showFavorite: favoriteIds.indexOf(item.id) >= 0,
        showDetail: item.id === selectedId,
        className: `danmaku-fly lane-${visible.length % 3} speed-${(visible.length % 3) + 1}${item.id === selectedId ? ' is-selected' : ''}`
      });
    }
  }
  return visible.slice(0, maxCount);
}

function buildNav(activeTab) {
  const tabs = [
    { id: 'live', label: '实时' },
    { id: 'persona', label: '人格' },
    { id: 'npc', label: 'NPC' },
    { id: 'memory', label: '记忆' },
    { id: 'recap', label: '回顾' },
    { id: 'safety', label: '设置' }
  ];
  return tabs.map((tab) => ({
    ...tab,
    active: tab.id === activeTab,
    className: tab.id === activeTab ? 'nav-chip is-active' : 'nav-chip'
  }));
}

function buildPersonaView(personas) {
  return personas.map((persona) => ({
    ...persona,
    stateText: persona.enabled ? 'ON' : 'OFF',
    strengthLabel: persona.strength === 1 ? '低' : persona.strength === 2 ? '中' : '高',
    toggleClass: persona.enabled ? 'toggle-btn is-active' : 'toggle-btn'
  }));
}

function buildSafetyView(items) {
  return items.map((item) => ({
    ...item,
    stateText: item.enabled ? 'ON' : 'OFF',
    toggleClass: item.enabled ? 'toggle-btn is-active' : 'toggle-btn'
  }));
}

function buildEmotionPoints(points) {
  return points.map((point) => ({
    ...point,
    className: `emotion-bar ${point.barClass}`
  }));
}

function getDataset(event) {
  const current = event && event.currentTarget && event.currentTarget.dataset;
  if (current) {
    return current;
  }
  const target = event && event.target && event.target.dataset;
  return target || {};
}

function buildFavoriteView(favoriteIds, generatedItems) {
  const items = [];
  const source = allDanmakuItems(generatedItems);
  for (let i = 0; i < favoriteIds.length; i += 1) {
    const danmaku = findById(source, favoriteIds[i]);
    if (danmaku) {
      items.push({
        id: danmaku.id,
        label: getPersonaName(danmaku.persona),
        value: danmaku.text
      });
    }
  }
  return items;
}

function selectedDanmakuDetail(id, generatedItems) {
  if (!id) {
    return null;
  }
  const item = findById(allDanmakuItems(generatedItems), id);
  if (!item) {
    return null;
  }
  return {
    ...item,
    personaName: getPersonaName(item.persona),
    avatar: getPersonaAvatar(item.persona)
  };
}

function normalizeSpeech(text) {
  return String(text || '')
    .toLowerCase()
    .replace(/[\s，。,.!?！？:：;；、"'“”‘’]/g, '');
}

function includesAny(text, keywords) {
  for (let i = 0; i < keywords.length; i += 1) {
    if (text.indexOf(keywords[i]) >= 0) {
      return true;
    }
  }
  return false;
}

function trimGeneratedText(text) {
  return String(text || '')
    .replace(/^[\s"'“”‘’]+|[\s"'“”‘’]+$/g, '')
    .replace(/\s+/g, ' ')
    .slice(0, 64);
}

function getLanguageModel() {
  if (typeof globalThis !== 'undefined' && globalThis.LanguageModel) {
    return globalThis.LanguageModel;
  }
  if (typeof window !== 'undefined' && window.LanguageModel) {
    return window.LanguageModel;
  }
  if (typeof LanguageModel !== 'undefined') {
    return LanguageModel;
  }
  return null;
}

function getWx() {
  if (typeof globalThis !== 'undefined' && globalThis.wx) {
    return globalThis.wx;
  }
  if (typeof window !== 'undefined' && window.wx) {
    return window.wx;
  }
  if (typeof wx !== 'undefined') {
    return wx;
  }
  return null;
}

function buildGeneratedDanmaku(sceneId, text, signal) {
  return {
    id: `generated-${Date.now()}`,
    scene: sceneId,
    persona: 'friend',
    text,
    tone: 'generated',
    toneLabel: '实时',
    intensity: 1,
    memoryReference: signal,
    reason: '来自眼镜端即时生成或本地回退。',
    safetyLevel: 'safe'
  };
}

function pickLocalFallback(sceneId) {
  for (let i = 0; i < DANMAKU.length; i += 1) {
    if (DANMAKU[i].scene === sceneId) {
      return DANMAKU[i].text;
    }
  }
  return '我已收到指令，先给你一条本地弹幕。';
}

console.log('Life Danmaku page script ready');

export default {
  data: {
    activeTab: 'live',
    activeSceneId: DEFAULT_SCENE_ID,
    activeSceneName: SCENES[0].name,
    activeSceneConfidence: SCENES[0].confidence,
    activeSceneSignal: SCENES[0].signal,
    activeSceneScan: SCENES[0].scan,
    sceneSourceText: '演示场景',
    liveScene: null,
    intensity: 2,
    intensityText: '中',
    paused: false,
    silentMode: false,
    selectedDanmakuId: '',
    hasSelectedDanmaku: false,
    showStageHint: true,
    selectedDanmaku: null,
    activeNpcIndex: 0,
    activeNpc: NPCS[0],
    favoriteIds: [],
    navTabs: buildNav('live'),
    personas: buildPersonaView(PERSONAS),
    danmakuList: buildDanmakuView(DEFAULT_SCENE_ID, PERSONAS, 2, false, false, '', [], []),
    hasNoDanmaku: false,
    npcList: NPCS,
    memoryItems: MEMORY_ITEMS,
    recapItems: RECAP_ITEMS,
    safetyItems: buildSafetyView(SAFETY_ITEMS),
    favoriteItems: [],
    quietTitle: '等待实时弹幕',
    quietCopy: '真实场景保持在 HUD 底层，AIUI 返回场景后叠加评论。',
    generatedDanmakuItems: [],
    listening: false,
    voiceAvailable: true,
    voiceStatus: '待命',
    voiceTranscript: '按语音或方向键测试',
    voiceAction: '实时弹幕',
    modelStatus: '待命',
    ttsStatus: '待命',
    topStatusMain: SCENES[0].scan,
    topStatusSub: SCENES[0].confidence,
    voiceButtonClass: 'voice-pill',
    voiceButtonLabel: '语音',
    silentButtonClass: 'mini-btn',
    silentButtonLabel: '正常',
    pauseButtonClass: 'mini-btn',
    pauseButtonLabel: '暂停',
    intensityOneClass: 'mini-btn',
    intensityTwoClass: 'mini-btn is-active',
    intensityThreeClass: 'mini-btn',
    npcOneClass: 'chip is-active',
    npcTwoClass: 'chip',
    emotionPoints: buildEmotionPoints([
      { label: '早', value: '38', barClass: 'bar-low' },
      { label: '午', value: '62', barClass: 'bar-mid' },
      { label: '晚', value: '81', barClass: 'bar-high' }
    ]),
    noJokesRule: '不拿身体、饮食、收入和亲密关系开玩笑。'
  },
  onLoad(query) {
    console.log('Life Danmaku page load');
    let sceneId = DEFAULT_SCENE_ID;
    if (query && query.initialScene) {
      sceneId = query.initialScene;
    }
    const liveScene = query && normalizeLiveScene(query.liveScene || query.sceneUnderstanding || query.scene);
    if (liveScene) {
      sceneId = liveScene.id;
    }
    this.applyState({
      activeSceneId: sceneId,
      liveScene,
      selectedDanmakuId: ''
    });
  },
  applyState(next) {
    const state = {
      activeTab: this.data.activeTab,
      activeSceneId: this.data.activeSceneId,
      liveScene: this.data.liveScene,
      intensity: this.data.intensity,
      paused: this.data.paused,
      silentMode: this.data.silentMode,
      selectedDanmakuId: this.data.selectedDanmakuId,
      hasSelectedDanmaku: this.data.hasSelectedDanmaku,
      showStageHint: this.data.showStageHint,
      personas: this.data.personas,
      safetyItems: this.data.safetyItems,
      activeNpcIndex: this.data.activeNpcIndex,
      favoriteIds: this.data.favoriteIds,
      generatedDanmakuItems: this.data.generatedDanmakuItems,
      listening: this.data.listening,
      voiceStatus: this.data.voiceStatus,
      voiceTranscript: this.data.voiceTranscript,
      voiceAction: this.data.voiceAction,
      modelStatus: this.data.modelStatus,
      ttsStatus: this.data.ttsStatus,
      ...next
    };
    const rawPersonas = state.personas.map((persona) => ({
      ...persona,
      enabled: persona.enabled,
      strength: persona.strength
    }));
    const knownScene = findExactById(SCENES, state.activeSceneId);
    const scene = state.liveScene && state.liveScene.id === state.activeSceneId
      ? state.liveScene
      : knownScene || DEFAULT_LIVE_SCENE;
    const isLiveScene = state.liveScene && state.liveScene.id === state.activeSceneId;
    const isKnownScene = !!knownScene;
    const selected = selectedDanmakuDetail(state.selectedDanmakuId, state.generatedDanmakuItems);
    const danmakuList = buildDanmakuView(
      state.activeSceneId,
      rawPersonas,
      state.intensity,
      state.silentMode,
      state.paused,
      state.selectedDanmakuId,
      state.favoriteIds,
      state.generatedDanmakuItems
    );
    const sceneSourceText = isLiveScene ? 'Live AI 场景' : isKnownScene ? '演示场景' : '等待场景输入';
    this.setData({
      ...state,
      activeSceneName: scene.name,
      activeSceneConfidence: scene.confidence,
      activeSceneSignal: scene.signal,
      activeSceneScan: scene.scan,
      sceneSourceText,
      intensityText: state.intensity === 1 ? '轻' : state.intensity === 2 ? '标准' : '热闹',
      navTabs: buildNav(state.activeTab),
      personas: buildPersonaView(rawPersonas),
      safetyItems: buildSafetyView(state.safetyItems),
      activeNpc: NPCS[state.activeNpcIndex],
      hasSelectedDanmaku: !!state.selectedDanmakuId,
      showStageHint: !state.selectedDanmakuId,
      selectedDanmaku: selected,
      quietTitle: state.paused ? '弹幕已暂停' : '等待实时弹幕',
      quietCopy: state.paused
        ? '眼镜只保留场景识别，不打扰当前注意力。'
        : '真实场景保持在 HUD 底层，AIUI 返回场景后叠加评论。',
      danmakuList,
      hasNoDanmaku: danmakuList.length === 0,
      topStatusMain: state.modelStatus && state.modelStatus !== '待命' ? state.modelStatus : scene.scan,
      topStatusSub: `${scene.confidence} ${state.ttsStatus || ''}`,
      voiceButtonClass: state.listening ? 'voice-pill is-active' : 'voice-pill',
      voiceButtonLabel: state.listening ? '听取中' : state.voiceStatus,
      silentButtonClass: state.silentMode ? 'mini-btn is-active' : 'mini-btn',
      silentButtonLabel: state.silentMode ? '静默' : '正常',
      pauseButtonClass: state.paused ? 'mini-btn is-active' : 'mini-btn',
      pauseButtonLabel: state.paused ? '继续' : '暂停',
      intensityOneClass: state.intensity === 1 ? 'mini-btn is-active' : 'mini-btn',
      intensityTwoClass: state.intensity === 2 ? 'mini-btn is-active' : 'mini-btn',
      intensityThreeClass: state.intensity === 3 ? 'mini-btn is-active' : 'mini-btn',
      npcOneClass: state.activeNpcIndex === 0 ? 'chip is-active' : 'chip',
      npcTwoClass: state.activeNpcIndex === 1 ? 'chip is-active' : 'chip',
      emotionPoints: buildEmotionPoints(this.data.emotionPoints),
      favoriteItems: buildFavoriteView(state.favoriteIds, state.generatedDanmakuItems)
    });
  },
  setVoiceStatus(next) {
    const listening = Object.prototype.hasOwnProperty.call(next, 'listening') ? next.listening : this.data.listening;
    const voiceStatus = next.voiceStatus || this.data.voiceStatus;
    this.setData({
      ...next,
      voiceButtonClass: listening ? 'voice-pill is-active' : 'voice-pill',
      voiceButtonLabel: listening ? '听取中' : voiceStatus
    });
  },
  setModelStatus(modelStatus) {
    this.setData({
      modelStatus,
      topStatusMain: modelStatus === '待命' ? this.data.activeSceneScan : modelStatus,
      topStatusSub: `${this.data.activeSceneConfidence} ${this.data.ttsStatus || ''}`
    });
  },
  setTtsStatus(ttsStatus) {
    this.setData({
      ttsStatus,
      topStatusMain: this.data.modelStatus === '待命' ? this.data.activeSceneScan : this.data.modelStatus,
      topStatusSub: `${this.data.activeSceneConfidence} ${ttsStatus}`
    });
  },
  toggleVoiceControl() {
    if (this.data.listening) {
      this.stopVoiceControl();
      return;
    }
    this.startVoiceControl();
  },
  startVoiceControl() {
    this.setVoiceStatus({
      listening: true,
      voiceAvailable: true,
      voiceStatus: '远程识别中',
      voiceTranscript: '等待 AIUI 语音识别返回',
      voiceAction: '识别语音意图'
    });

    if (typeof SpeechRecognition === 'function') {
      try {
        const recognition = new SpeechRecognition();
        recognition.lang = 'zh-CN';
        recognition.interimResults = false;
        recognition.maxAlternatives = 1;
        this.recognition = recognition;
        recognition.onresult = (event) => {
          const result = event && event.results && event.results[event.resultIndex || 0];
          const first = result && result[0];
          const transcript = first && first.transcript ? first.transcript : '';
          this.routeVoiceCommand(transcript);
        };
        recognition.onerror = (event) => {
          this.setVoiceStatus({
            listening: false,
            voiceStatus: '识别失败',
            voiceTranscript: event && event.message ? event.message : '语音识别失败',
            voiceAction: '请重试'
          });
        };
        recognition.onend = () => {
          if (this.data.listening) {
            this.setVoiceStatus({
              listening: false,
              voiceStatus: '已结束',
              voiceAction: '语音识别已结束'
            });
          }
        };
        recognition.start();
        return;
      } catch (error) {
        console.log('SpeechRecognition start failed', error);
      }
    }

    const wxApi = getWx();
    if (!wxApi || !wxApi.speech || typeof wxApi.speech.startRecognition !== 'function') {
      this.setVoiceStatus({
        voiceAvailable: false,
        listening: false,
        voiceStatus: '不可用',
        voiceTranscript: '当前宿主没有语音识别能力',
        voiceAction: '请用方向键或点击控件'
      });
      return;
    }

    try {
      const transcript = wxApi.speech.startRecognition();
      this.routeVoiceCommand(transcript);
    } catch (error) {
      this.setVoiceStatus({
        listening: false,
        voiceStatus: '启动失败',
        voiceTranscript: error && error.message ? error.message : 'AIUI 远程语音识别启动失败',
        voiceAction: '请重新发起语音识别'
      });
    }
  },
  stopVoiceControl() {
    if (this.recognition && typeof this.recognition.stop === 'function') {
      try {
        this.recognition.stop();
      } catch (error) {
        console.log('SpeechRecognition stop failed', error);
      }
    }
    this.setVoiceStatus({
      listening: false,
      voiceStatus: '已取消',
      voiceAction: '本次远程语音识别已取消'
    });
  },
  routeVoiceCommand(rawText) {
    const text = normalizeSpeech(rawText);
    if (!text) {
      this.setVoiceStatus({
        listening: false,
        voiceStatus: '未听清',
        voiceTranscript: '没有识别到有效语音',
        voiceAction: '请重试'
      });
      return;
    }

    const command = this.resolveVoiceCommand(text);
    if (!command) {
      this.setVoiceStatus({
        listening: false,
        voiceStatus: '未匹配',
        voiceTranscript: rawText,
        voiceAction: '未匹配语音意图'
      });
      return;
    }

    command.run();
    this.setVoiceStatus({
      listening: false,
      voiceStatus: '已执行',
      voiceTranscript: rawText,
      voiceAction: command.label
    });
  },
  resolveVoiceCommand(text) {
    const tabCommands = [
      { id: 'live', label: '切到实时', keys: ['实时', '直播', '弹幕'] },
      { id: 'persona', label: '切到人格', keys: ['人格', '评论团'] },
      { id: 'npc', label: '切到 NPC', keys: ['npc', '人物'] },
      { id: 'memory', label: '切到记忆', keys: ['记忆', '数据库', '名场面'] },
      { id: 'recap', label: '切到回顾', keys: ['回顾', '昨日', '高光'] },
      { id: 'safety', label: '切到设置', keys: ['设置', '安全', '规则'] }
    ];
    for (let i = 0; i < tabCommands.length; i += 1) {
      const item = tabCommands[i];
      if (includesAny(text, item.keys)) {
        return {
          label: item.label,
          run: () => this.applyState({ activeTab: item.id })
        };
      }
    }

    const sceneCommands = [
      { id: 'street', label: '场景：街道', keys: ['街道', '路上', '马路'] },
      { id: 'cafe', label: '场景：咖啡店', keys: ['咖啡', '咖啡店'] },
      { id: 'office', label: '场景：办公室', keys: ['办公室', '工作'] },
      { id: 'gym', label: '场景：健身房', keys: ['健身', '健身房'] },
      { id: 'store', label: '场景：便利店', keys: ['便利店', '商店'] },
      { id: 'subway', label: '场景：地铁', keys: ['地铁', '通勤'] }
    ];
    for (let i = 0; i < sceneCommands.length; i += 1) {
      const item = sceneCommands[i];
      if (includesAny(text, item.keys)) {
        return {
          label: item.label,
          run: () => this.applyState({
            activeTab: 'live',
            activeSceneId: item.id,
            selectedDanmakuId: ''
          })
        };
      }
    }

    if (includesAny(text, ['暂停', '停一下', '停'])) {
      return {
        label: '暂停弹幕',
        run: () => this.applyState({ paused: true })
      };
    }
    if (includesAny(text, ['继续', '恢复', '开始'])) {
      return {
        label: '继续弹幕',
        run: () => this.applyState({ paused: false })
      };
    }
    if (includesAny(text, ['取消静默', '关闭静默', '正常说'])) {
      return {
        label: '关闭静默',
        run: () => this.applyState({ silentMode: false })
      };
    }
    if (includesAny(text, ['静默', '安静', '少说'])) {
      return {
        label: '开启静默',
        run: () => this.applyState({ silentMode: true })
      };
    }
    if (includesAny(text, ['轻一点', '轻', '低强度'])) {
      return {
        label: '强度：轻',
        run: () => this.applyState({ intensity: 1 })
      };
    }
    if (includesAny(text, ['标准', '中等', '正常'])) {
      return {
        label: '强度：标准',
        run: () => this.applyState({ intensity: 2 })
      };
    }
    if (includesAny(text, ['热闹', '更狠', '高强度'])) {
      return {
        label: '强度：热闹',
        run: () => this.applyState({ intensity: 3 })
      };
    }
    if (includesAny(text, ['小王'])) {
      return {
        label: 'NPC：小王',
        run: () => this.applyState({ activeTab: 'npc', activeNpcIndex: 0 })
      };
    }
    if (includesAny(text, ['emily', '艾米丽'])) {
      return {
        label: 'NPC：Emily',
        run: () => this.applyState({ activeTab: 'npc', activeNpcIndex: 1 })
      };
    }
    if (includesAny(text, ['收藏', '保存']) && this.data.selectedDanmakuId) {
      return {
        label: '收藏当前弹幕',
        run: () => this.applyFeedbackAction('collect')
      };
    }
    if (includesAny(text, ['太狠', '太重', '别这么说'])) {
      return {
        label: '降低强度',
        run: () => this.applyFeedbackAction('tooHard')
      };
    }
    if (includesAny(text, ['别说', '屏蔽', '不许说'])) {
      return {
        label: '加入禁用规则',
        run: () => this.applyFeedbackAction('block')
      };
    }
    if (includesAny(text, ['生成', '来一条', '写一条', '新弹幕'])) {
      return {
        label: '生成实时弹幕',
        run: () => this.generateLiveDanmaku()
      };
    }
    if (includesAny(text, ['播报', '读出来', '念出来'])) {
      return {
        label: '播报弹幕',
        run: () => this.speakCurrentDanmaku()
      };
    }
    return null;
  },
  async generateLiveDanmaku() {
    this.setModelStatus('生成中');
    try {
      const model = getLanguageModel();
      if (!model || typeof model.availability !== 'function' || typeof model.create !== 'function') {
        const item = buildGeneratedDanmaku(
          this.data.activeSceneId,
          pickLocalFallback(this.data.activeSceneId),
          this.data.activeSceneSignal
        );
        this.applyState({
          activeTab: 'live',
          generatedDanmakuItems: [item].concat(this.data.generatedDanmakuItems).slice(0, 5),
          selectedDanmakuId: item.id,
          modelStatus: '无模型'
        });
        return;
      }
      const availability = await model.availability();
      if (availability !== 'available') {
        const item = buildGeneratedDanmaku(
          this.data.activeSceneId,
          pickLocalFallback(this.data.activeSceneId),
          this.data.activeSceneSignal
        );
        this.applyState({
          activeTab: 'live',
          generatedDanmakuItems: [item].concat(this.data.generatedDanmakuItems).slice(0, 5),
          selectedDanmakuId: item.id,
          modelStatus: '本地回退'
        });
        return;
      }
      const session = await model.create({
        initialPrompts: [
          {
            role: 'system',
            content: '你是 Rokid Glass 上的人生弹幕生成器。输出一条中文短弹幕，幽默但不攻击身体、收入、身份、饮食和亲密关系。只输出弹幕正文。'
          }
        ]
      });
      const rawText = await session.prompt(
        `场景：${this.data.activeSceneName}。线索：${this.data.activeSceneSignal}。强度：${this.data.intensityText}。请生成一条 28 字以内的人生弹幕。`
      );
      const text = trimGeneratedText(rawText);
      if (!text) {
        this.setModelStatus('空结果');
        return;
      }
      const item = buildGeneratedDanmaku(this.data.activeSceneId, text, this.data.activeSceneSignal);
      item.intensity = Math.max(1, Math.min(3, this.data.intensity));
      item.reason = '来自 AIUI 远程模型实时生成。';
      this.applyState({
        activeTab: 'live',
        generatedDanmakuItems: [item].concat(this.data.generatedDanmakuItems).slice(0, 5),
        selectedDanmakuId: item.id,
        modelStatus: '已生成'
      });
    } catch (error) {
      console.log('generateLiveDanmaku failed', error);
      const item = buildGeneratedDanmaku(
        this.data.activeSceneId,
        pickLocalFallback(this.data.activeSceneId),
        this.data.activeSceneSignal
      );
      this.applyState({
        activeTab: 'live',
        generatedDanmakuItems: [item].concat(this.data.generatedDanmakuItems).slice(0, 5),
        selectedDanmakuId: item.id,
        modelStatus: '生成失败'
      });
    }
  },
  speakCurrentDanmaku() {
    const selected = selectedDanmakuDetail(this.data.selectedDanmakuId, this.data.generatedDanmakuItems);
    const first = this.data.danmakuList && this.data.danmakuList[0];
    const text = selected && selected.text ? selected.text : first && first.text ? first.text : '';
    if (!text) {
      this.setTtsStatus('无弹幕');
      return;
    }
    const wxApi = getWx();
    if (!wxApi || !wxApi.speech || typeof wxApi.speech.playTTS !== 'function') {
      this.setTtsStatus('TTS 不可用');
      return;
    }
    try {
      const taskId = wxApi.speech.playTTS(text);
      this.setTtsStatus(taskId ? '播报中' : '播报失败');
    } catch (error) {
      console.log('speakCurrentDanmaku failed', error);
      this.setTtsStatus('播报失败');
    }
  },
  setTab(event) {
    const data = getDataset(event);
    const nextTab = data.id || TAB_SEQUENCE[(TAB_SEQUENCE.indexOf(this.data.activeTab) + 1) % TAB_SEQUENCE.length];
    this.applyState({
      activeTab: nextTab
    });
  },
  setIntensity(event) {
    const value = Number(getDataset(event).value || 2);
    this.applyState({ intensity: value });
  },
  setIntensityLow() {
    this.applyState({ intensity: 1 });
  },
  setIntensityMedium() {
    this.applyState({ intensity: 2 });
  },
  setIntensityHigh() {
    this.applyState({ intensity: 3 });
  },
  togglePause() {
    this.applyState({ paused: !this.data.paused });
  },
  toggleSilent() {
    this.applyState({ silentMode: !this.data.silentMode });
  },
  selectDanmaku(event) {
    const id = getDataset(event).id;
    if (!id) {
      this.setModelStatus('未取到弹幕');
      return;
    }
    this.applyState({
      selectedDanmakuId: id
    });
  },
  togglePersona(event) {
    const id = getDataset(event).id;
    if (!id) {
      this.setModelStatus('未取到人格');
      return;
    }
    const personas = this.data.personas.map((persona) => {
      if (persona.id === id) {
        return {
          ...persona,
          enabled: !persona.enabled
        };
      }
      return persona;
    });
    this.applyState({ personas });
  },
  cyclePersonaStrength(event) {
    const id = getDataset(event).id;
    if (!id) {
      this.setModelStatus('未取到强度');
      return;
    }
    const personas = this.data.personas.map((persona) => {
      if (persona.id === id) {
        return {
          ...persona,
          strength: persona.strength >= 3 ? 1 : persona.strength + 1
        };
      }
      return persona;
    });
    this.applyState({ personas });
  },
  setNpc(event) {
    const index = Number(getDataset(event).index || 0);
    this.applyState({
      activeTab: 'npc',
      activeNpcIndex: index
    });
  },
  setNpcFirst() {
    this.applyState({
      activeTab: 'npc',
      activeNpcIndex: 0
    });
  },
  setNpcSecond() {
    this.applyState({
      activeTab: 'npc',
      activeNpcIndex: 1
    });
  },
  feedback(event) {
    const type = getDataset(event).type;
    if (!type) {
      this.setModelStatus('未取到反馈');
      return;
    }
    this.applyFeedbackAction(type);
  },
  applyFeedbackAction(type) {
    if (type === 'collect') {
      const id = this.data.selectedDanmakuId;
      if (!id) {
        return;
      }
      const existing = this.data.favoriteIds.indexOf(id) >= 0;
      const nextFavorites = existing
        ? this.data.favoriteIds.filter((itemId) => itemId !== id)
        : this.data.favoriteIds.concat(id);
      this.applyState({ favoriteIds: nextFavorites });
      return;
    }
    if (type === 'block') {
      this.applyState({
        silentMode: true,
        noJokesRule: '已加入：不要再围绕这条记忆开玩笑。'
      });
      return;
    }
    if (type === 'tooHard') {
      this.applyState({
        intensity: 1,
        silentMode: true
      });
      return;
    }
    this.applyState({
      selectedDanmakuId: this.data.selectedDanmakuId
    });
  },
  toggleSafety(event) {
    const id = getDataset(event).id;
    if (!id) {
      this.setModelStatus('未取到设置');
      return;
    }
    const safetyItems = this.data.safetyItems.map((item) => {
      if (item.id === id) {
        return {
          ...item,
          enabled: !item.enabled
        };
      }
      return item;
    });
    this.applyState({ safetyItems });
  },
  onKeyDown(event) {
    const key = event && (event.key || event.code);
    if (key === 'ArrowRight') {
      const index = TAB_SEQUENCE.indexOf(this.data.activeTab);
      this.applyState({ activeTab: TAB_SEQUENCE[(index + 1) % TAB_SEQUENCE.length] });
    }
    if (key === 'ArrowLeft') {
      const index = TAB_SEQUENCE.indexOf(this.data.activeTab);
      this.applyState({ activeTab: TAB_SEQUENCE[(index + TAB_SEQUENCE.length - 1) % TAB_SEQUENCE.length] });
    }
    if (key === 'ArrowUp') {
      this.toggleVoiceControl();
    }
    if (key === 'ArrowDown') {
      this.toggleSilent();
    }
    if (key === 'Enter') {
      this.togglePause();
    }
  }
};
</script>

<page>
  <view class="app-shell">
    <view class="hud-frame">
      <view class="topbar">
        <view class="brand">
          <text class="eyebrow">LIFE DANMAKU</text>
          <text class="title">人生弹幕层</text>
        </view>
        <view class="top-status">
          <view class="status-pill">
            <text class="status-main">{{ topStatusMain }}</text>
            <text class="status-sub">{{ topStatusSub }}</text>
          </view>
          <button class="{{ voiceButtonClass }}" bindtap="toggleVoiceControl">
            <view class="voice-dot"></view>
            <text>{{ voiceButtonLabel }}</text>
          </button>
        </view>
      </view>

      <view class="content">
        <view class="module-rail">
          <view ink:for="{{ navTabs }}" ink:key="id" class="nav-slot">
            <button data-id="{{ item.id }}" class="{{ item.className }}" bindtap="setTab">{{ item.label }}</button>
          </view>
        </view>

        <view ink:if="{{ activeTab === 'live' }}" class="panel live-panel">
          <view class="world-scene">
            <view class="world-reticle"></view>
            <view class="scene-anchor">
              <view class="scene-meta">
                <text class="section-kicker">{{ sceneSourceText }}</text>
                <text class="meta-chip">{{ activeSceneConfidence }}</text>
              </view>
              <text class="scene-name">{{ activeSceneName }}</text>
              <text class="scene-signal">{{ activeSceneSignal }}</text>
              <view class="scan-line"></view>
            </view>
            <view
              ink:for="{{ danmakuList }}"
              ink:key="id"
              data-id="{{ item.id }}"
              class="{{ item.className }}"
              bindtap="selectDanmaku"
            >
              <view class="avatar">{{ item.avatar }}</view>
              <view class="bubble-body">
                <view class="bubble-meta">
                  <text class="persona-name">{{ item.personaName }}</text>
                  <text class="tone-tag">{{ item.toneLabel }}</text>
                  <text class="fav-tag" ink:if="{{ item.showFavorite }}">已藏</text>
                </view>
                <text class="bubble-text">{{ item.text }}</text>
                <view class="inline-detail" ink:if="{{ item.showDetail }}">
                  <text class="detail-title">已锁定弹幕</text>
                  <text class="detail-copy">{{ item.reason }}</text>
                  <text class="memory-ref">记忆：{{ item.memoryReference }}</text>
                  <view class="feedback-row">
                    <button class="mini-btn" data-type="funny" catchtap="feedback">好笑</button>
                    <button class="mini-btn" data-type="tooHard" catchtap="feedback">太狠</button>
                    <button class="mini-btn" data-type="block" catchtap="feedback">别说</button>
                    <button class="mini-btn" data-type="collect" catchtap="feedback">收藏</button>
                  </view>
                </view>
              </view>
            </view>
            <view class="quiet-card" ink:if="{{ hasNoDanmaku }}">
              <text class="quiet-title">{{ quietTitle }}</text>
              <text class="quiet-copy">{{ quietCopy }}</text>
            </view>
          </view>
          <view class="control-strip">
            <view class="intensity-group">
              <button class="{{ intensityOneClass }}" bindtap="setIntensityLow">轻</button>
              <button class="{{ intensityTwoClass }}" bindtap="setIntensityMedium">标准</button>
              <button class="{{ intensityThreeClass }}" bindtap="setIntensityHigh">热闹</button>
            </view>
            <button class="{{ silentButtonClass }}" bindtap="toggleSilent">{{ silentButtonLabel }}</button>
            <button class="{{ pauseButtonClass }}" bindtap="togglePause">{{ pauseButtonLabel }}</button>
            <button class="mini-btn strong-btn" bindtap="generateLiveDanmaku">生成</button>
            <button class="mini-btn" bindtap="speakCurrentDanmaku">播报</button>
          </view>
        </view>

        <view ink:elif="{{ activeTab === 'persona' }}" class="panel split-panel">
          <scroll-view class="persona-list" scroll-y="true">
            <view ink:for="{{ personas }}" ink:key="id" class="persona-card">
              <view class="persona-avatar">{{ item.avatar }}</view>
              <view class="persona-main">
                <view class="persona-row">
                  <text class="persona-title">{{ item.name }}</text>
                  <button data-id="{{ item.id }}" class="{{ item.toggleClass }}" bindtap="togglePersona">{{ item.stateText }}</button>
                </view>
                <text class="persona-desc">{{ item.description }}</text>
                <text class="persona-example">示例：{{ item.example }}</text>
                <view class="persona-foot">
                  <text class="tone-text">{{ item.tone }}</text>
                  <button data-id="{{ item.id }}" class="mini-btn" bindtap="cyclePersonaStrength">强度 {{ item.strengthLabel }}</button>
                </view>
              </view>
            </view>
          </scroll-view>
          <view class="side-note">
            <text class="side-title">多人格评论团</text>
            <text class="side-copy">不是一个 AI 陪你生活，而是一整个观众席在看你通关人生。</text>
          </view>
        </view>

        <view ink:elif="{{ activeTab === 'npc' }}" class="panel npc-panel">
          <view class="npc-switch">
            <button class="{{ npcOneClass }}" bindtap="setNpcFirst">小王</button>
            <button class="{{ npcTwoClass }}" bindtap="setNpcSecond">Emily</button>
          </view>
          <view class="npc-card">
            <view class="npc-header">
              <view>
                <text class="npc-name">{{ activeNpc.name }}</text>
                <text class="npc-role">{{ activeNpc.role }} / {{ activeNpc.status }}</text>
              </view>
              <text class="npc-level">{{ activeNpc.level }}</text>
            </view>
            <view class="stat-grid">
              <view class="stat-box">
                <text class="stat-value">{{ activeNpc.familiarity }}</text>
                <text class="stat-label">熟悉度</text>
              </view>
              <view class="stat-box">
                <text class="stat-value">{{ activeNpc.trust }}</text>
                <text class="stat-label">信任度</text>
              </view>
              <view class="stat-box">
                <text class="stat-value">{{ activeNpc.lastSeen }}</text>
                <text class="stat-label">最近互动</text>
              </view>
            </view>
            <text class="npc-line">隐藏属性：{{ activeNpc.hidden }}</text>
            <text class="npc-line">历史关键词：{{ activeNpc.keywords }}</text>
            <text class="npc-line">今日建议：{{ activeNpc.advice }}</text>
            <view class="roast-box">
              <text>{{ activeNpc.roast }}</text>
            </view>
          </view>
          <text class="slogan">你的生活，其实早就是开放世界游戏。</text>
        </view>

        <view ink:elif="{{ activeTab === 'memory' }}" class="panel memory-panel">
          <view class="memory-head">
            <text class="side-title">记忆数据库</text>
            <text class="side-copy">AI 比我还记得我自己。</text>
          </view>
          <scroll-view class="memory-list" scroll-y="true">
            <view ink:for="{{ memoryItems }}" ink:key="id" class="memory-card">
              <text class="memory-type">{{ item.type }} / {{ item.weight }}</text>
              <text class="memory-title">{{ item.title }}</text>
              <text class="memory-detail">{{ item.detail }}</text>
            </view>
          </scroll-view>
          <view class="favorites-card">
            <text class="detail-title">我的人生名场面</text>
            <view ink:if="{{ favoriteItems.length === 0 }}">
              <text class="detail-copy">收藏的弹幕会沉淀为昨日高光候选。</text>
            </view>
            <view ink:for="{{ favoriteItems }}" ink:key="id" class="fav-line">
              <text class="memory-type">{{ item.label }}</text>
              <text class="memory-detail">{{ item.value }}</text>
            </view>
          </view>
        </view>

        <view ink:elif="{{ activeTab === 'recap' }}" class="panel recap-panel">
          <view class="recap-main">
            <text class="recap-title">昨日高光</text>
            <view class="emotion-chart">
              <view ink:for="{{ emotionPoints }}" ink:key="label" class="emotion-point">
                <view class="{{ item.className }}"></view>
                <text class="emotion-value">{{ item.value }}</text>
                <text class="emotion-label">{{ item.label }}</text>
              </view>
            </view>
          </view>
          <scroll-view class="recap-list" scroll-y="true">
            <view ink:for="{{ recapItems }}" ink:key="id" class="recap-row">
              <text class="recap-label">{{ item.label }}</text>
              <text class="recap-value">{{ item.value }}</text>
            </view>
          </scroll-view>
        </view>

        <view ink:else class="panel safety-panel">
          <view class="safety-head">
            <text class="side-title">静默与安全</text>
            <text class="side-copy">AI 可以幽默，但不能伤害用户。</text>
          </view>
          <scroll-view class="safety-list" scroll-y="true">
            <view ink:for="{{ safetyItems }}" ink:key="id" class="safety-row">
              <view class="safety-copy">
                <text class="safety-title">{{ item.title }}</text>
                <text class="safety-detail">{{ item.detail }}</text>
              </view>
              <button data-id="{{ item.id }}" class="{{ item.toggleClass }}" bindtap="toggleSafety">{{ item.stateText }}</button>
            </view>
          </scroll-view>
          <view class="rule-box">
            <text class="memory-type">不许开的玩笑</text>
            <text class="memory-detail">{{ noJokesRule }}</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</page>

<style>
.app-shell {
  width: var(--app-width);
  min-height: var(--app-height-min);
  max-height: var(--app-height-max);
  background-color: var(--color-background);
  color: var(--color-text-primary);
  box-sizing: border-box;
  padding: 8px 12px;
  overflow: hidden;
}

.hud-frame {
  position: relative;
  width: 100%;
  height: 344px;
  box-sizing: border-box;
  border: 0;
  border-radius: 0;
  background-color: var(--color-surface);
  padding: 0;
  overflow: hidden;
}

.topbar {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  gap: var(--spacing-md);
  height: 44px;
}

.brand {
  display: flex;
  flex-direction: column;
  gap: 2px;
  width: 154px;
  padding: 5px 9px;
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-sm);
  background-color: var(--input-background-color);
  box-sizing: border-box;
  overflow: hidden;
}

.eyebrow {
  color: var(--color-text-secondary);
  font-size: 11px;
  line-height: 13px;
}

.title {
  color: var(--color-text-primary);
  font-size: 18px;
  line-height: 20px;
  font-weight: 700;
  white-space: nowrap;
}

.top-status {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 6px;
}

.status-pill {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 2px;
  min-width: 104px;
  border: var(--border-width-thin) solid var(--border-color-accent);
  border-radius: var(--radius-sm);
  padding: 5px 10px;
  color: var(--color-text-primary);
  background-color: var(--input-background-color);
}

.status-main {
  color: var(--color-text-primary);
  font-size: 12px;
  line-height: 13px;
  font-weight: 700;
}

.status-sub {
  color: var(--color-text-secondary);
  font-size: 10px;
  line-height: 11px;
}

.voice-pill {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 5px;
  height: 28px;
  padding: 0 9px;
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-sm);
  box-sizing: border-box;
  background-color: var(--input-background-color);
  color: var(--color-text-secondary);
  font-size: 10px;
  line-height: 12px;
}

.voice-pill.is-active {
  color: var(--color-text-primary);
  border-color: var(--border-color-accent);
}

.voice-dot {
  width: 8px;
  height: 8px;
  border-radius: var(--radius-sm);
  border: var(--border-width-thin) solid var(--border-color-accent);
  background-color: var(--color-surface);
}

.voice-pill.is-active .voice-dot {
  background-color: var(--color-primary-60);
}

button {
  color: var(--color-text-secondary);
  background-color: var(--color-surface);
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-sm);
  padding: 0 8px;
  font-size: 12px;
  line-height: 22px;
  min-height: 26px;
  white-space: nowrap;
}

.is-active {
  color: var(--color-text-primary);
  border-color: var(--border-color-accent);
  background-color: var(--input-background-color);
}

.content {
  height: 292px;
  margin-top: 8px;
  overflow: hidden;
}

.panel {
  height: 292px;
  width: 100%;
  box-sizing: border-box;
  overflow: hidden;
}

.live-panel {
  position: relative;
  display: block;
}

.scene-anchor,
.detail-card,
.side-note,
.npc-card,
.favorites-card,
.rule-box {
  border: var(--card-border-width) solid var(--card-border-color);
  border-radius: var(--radius-md);
  padding: 10px;
  box-sizing: border-box;
  background-color: var(--input-background-color);
}

.world-scene {
  position: relative;
  width: 100%;
  height: 292px;
  overflow: hidden;
  border: 0;
  border-radius: 0;
  box-sizing: border-box;
  background-color: var(--input-background-color);
}

.scene-anchor {
  position: absolute;
  left: 4px;
  top: 4px;
  width: 184px;
  z-index: 2;
}

.scene-meta,
.signal-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  gap: var(--spacing-sm);
}

.meta-chip {
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-sm);
  padding: 1px 6px;
  color: var(--color-text-primary);
  font-size: 10px;
  line-height: 13px;
}

.signal-label {
  color: var(--color-text-secondary);
  font-size: 10px;
  line-height: 12px;
}

.signal-value {
  flex: 1;
  color: var(--color-text-primary);
  font-size: 11px;
  line-height: 13px;
  text-align: right;
  max-height: 26px;
  overflow: hidden;
}

.section-kicker,
.memory-type {
  color: var(--color-text-secondary);
  font-size: 11px;
  line-height: 13px;
}

.scene-name {
  margin-top: 4px;
  color: var(--color-text-primary);
  font-size: 18px;
  line-height: 21px;
  font-weight: 700;
}

.scene-signal,
.memory-line,
.silent-hint {
  margin-top: 6px;
  color: var(--color-text-secondary);
  font-size: 11px;
  line-height: 14px;
  word-break: normal;
}

.scene-signal {
  max-height: 44px;
  overflow: hidden;
}

.silent-hint {
  color: var(--color-text-primary);
}

.scan-line {
  height: 2px;
  margin-top: 8px;
  background-color: var(--color-primary-60);
  animation: scanPulse 1.8s ease-in-out infinite;
}

.feedback-row,
.persona-foot,
.npc-switch {
  display: flex;
  flex-direction: row;
  gap: var(--spacing-sm);
}

.chip {
  height: 28px;
  min-width: 42px;
  padding: 0 8px;
  white-space: nowrap;
}

.world-reticle {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 112px;
  height: 58px;
  border-top: var(--border-width-thin) solid var(--border-color-muted);
  border-bottom: var(--border-width-thin) solid var(--border-color-muted);
  transform: translate(-50%, -50%);
  opacity: 0.28;
}

.danmaku-fly {
  position: absolute;
  left: 100%;
  display: flex;
  flex-direction: row;
  gap: var(--spacing-sm);
  width: 266px;
  min-height: 54px;
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-md);
  padding: var(--spacing-sm);
  box-sizing: border-box;
  background-color: var(--color-surface);
  animation-name: danmakuDrift;
  animation-timing-function: linear;
  animation-iteration-count: infinite;
  animation-fill-mode: both;
}

.danmaku-fly.is-selected {
  z-index: 3;
  left: 8px;
  right: 8px;
  top: 18px;
  width: auto;
  max-height: 180px;
  overflow: hidden;
  animation-name: none;
  border-width: var(--border-width-default);
  border-color: var(--border-color-accent);
  background-color: var(--input-background-color);
}

.lane-0 {
  top: 28px;
}

.lane-1 {
  top: 112px;
}

.lane-2 {
  top: 196px;
}

.speed-1 {
  animation-duration: 12s;
  animation-delay: -5s;
}

.speed-2 {
  animation-duration: 14s;
  animation-delay: -8s;
}

.speed-3 {
  animation-duration: 16s;
  animation-delay: -11s;
}

.avatar,
.persona-avatar {
  width: 28px;
  height: 28px;
  min-width: 28px;
  border-radius: var(--radius-sm);
  border: var(--border-width-thin) solid var(--border-color-accent);
  color: var(--color-text-primary);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 13px;
  line-height: 28px;
  font-weight: 700;
}

.bubble-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.bubble-meta,
.detail-head,
.persona-row,
.npc-header,
.memory-head,
.safety-head,
.recap-main {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  gap: var(--spacing-sm);
}

.persona-name,
.detail-title,
.side-title,
.safety-title {
  color: var(--color-text-primary);
  font-size: 14px;
  line-height: 16px;
  font-weight: 700;
}

.tone-tag,
.fav-tag,
.detail-persona,
.tone-text {
  color: var(--color-text-secondary);
  font-size: 11px;
  line-height: 13px;
}

.bubble-text {
  color: var(--color-text-primary);
  font-size: 13px;
  line-height: 17px;
  word-break: normal;
}

.inline-detail {
  margin-top: 6px;
  padding-top: 6px;
  border-top: var(--border-width-thin) solid var(--border-color-muted);
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.quiet-card {
  position: absolute;
  right: 6px;
  bottom: 8px;
  width: 248px;
  min-height: 58px;
  border: var(--border-width-default) solid var(--border-color-muted);
  border-radius: var(--radius-md);
  padding: 10px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  justify-content: center;
  background-color: var(--input-background-color);
  z-index: 2;
}

.quiet-title {
  font-size: 14px;
  line-height: 17px;
  color: var(--color-text-primary);
}

.quiet-copy,
.side-copy,
.detail-copy,
.memory-ref,
.persona-desc,
.persona-example,
.npc-line,
.slogan,
.safety-detail {
  color: var(--color-text-secondary);
  font-size: 11px;
  line-height: 14px;
}

.detail-card {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.mini-btn {
  height: 26px;
  min-width: 48px;
  padding: 0 6px;
  font-size: 12px;
  line-height: 22px;
  white-space: nowrap;
}

.split-panel {
  display: grid;
  grid-template-columns: 1fr 150px;
  gap: var(--spacing-sm);
}

.persona-list,
.memory-list,
.recap-list,
.safety-list {
  height: 292px;
  overflow: hidden;
}

.persona-card {
  display: flex;
  flex-direction: row;
  gap: var(--spacing-sm);
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-md);
  padding: var(--spacing-sm);
  margin-bottom: var(--spacing-sm);
  box-sizing: border-box;
}

.persona-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.persona-title,
.memory-title,
.npc-name,
.recap-title {
  color: var(--color-text-primary);
  font-size: 16px;
  line-height: 18px;
  font-weight: 700;
}

.toggle-btn {
  height: 26px;
  min-width: 46px;
  padding: 0 8px;
  font-size: 12px;
}

.side-note {
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: var(--spacing-md);
}

.npc-panel {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.npc-card {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.npc-role {
  margin-top: 4px;
  color: var(--color-text-secondary);
  font-size: 12px;
  line-height: 14px;
}

.npc-level {
  color: var(--color-text-primary);
  font-size: 20px;
  line-height: 22px;
  font-weight: 700;
}

.stat-grid {
  display: grid;
  grid-template-columns: 1fr 1fr 1.2fr;
  gap: var(--spacing-sm);
}

.stat-box {
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.stat-value {
  color: var(--color-text-primary);
  font-size: 15px;
  line-height: 17px;
  font-weight: 700;
}

.stat-label {
  color: var(--color-text-secondary);
  font-size: 11px;
  line-height: 13px;
}

.roast-box {
  border-left: var(--border-width-strong) solid var(--border-color-accent);
  padding-left: var(--spacing-sm);
  color: var(--color-text-primary);
  font-size: 13px;
  line-height: 17px;
}

.slogan {
  text-align: center;
}

.memory-panel {
  display: grid;
  grid-template-columns: 1fr 170px;
  grid-template-rows: 34px 1fr;
  gap: var(--spacing-sm);
}

.memory-head {
  grid-column: 1 / 3;
}

.memory-card {
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-md);
  padding: var(--spacing-sm);
  margin-bottom: var(--spacing-sm);
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.memory-detail,
.recap-value {
  color: var(--color-text-secondary);
  font-size: 12px;
  line-height: 16px;
}

.favorites-card {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
  overflow: hidden;
}

.fav-line {
  border-top: var(--border-width-thin) solid var(--border-color-muted);
  padding-top: var(--spacing-sm);
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.recap-panel {
  display: grid;
  grid-template-columns: 200px 1fr;
  gap: var(--spacing-sm);
}

.recap-main {
  align-items: flex-start;
  flex-direction: column;
  border: var(--border-width-default) solid var(--border-color-default);
  border-radius: var(--radius-md);
  padding: var(--spacing-md);
  box-sizing: border-box;
  background-color: var(--input-background-color);
}

.emotion-chart {
  width: 190px;
  height: 92px;
  display: flex;
  flex-direction: row;
  align-items: flex-end;
  justify-content: space-between;
  gap: var(--spacing-sm);
}

.emotion-point {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.emotion-bar {
  width: 34px;
  border: var(--border-width-thin) solid var(--border-color-accent);
  border-radius: var(--radius-sm);
  background-color: var(--input-background-color);
}

.bar-low {
  height: 34px;
}

.bar-mid {
  height: 56px;
}

.bar-high {
  height: 78px;
}

.emotion-value {
  color: var(--color-text-primary);
  font-size: 12px;
  line-height: 13px;
}

.emotion-label {
  color: var(--color-text-secondary);
  font-size: 11px;
  line-height: 12px;
}

.recap-row {
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-md);
  padding: var(--spacing-sm);
  margin-bottom: var(--spacing-sm);
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.recap-label {
  color: var(--color-text-primary);
  font-size: 13px;
  line-height: 15px;
  font-weight: 700;
}

.safety-panel {
  display: grid;
  grid-template-columns: 1fr 170px;
  grid-template-rows: 36px 1fr;
  gap: var(--spacing-sm);
}

.safety-head {
  grid-column: 1 / 3;
}

.safety-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  gap: var(--spacing-sm);
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-md);
  padding: var(--spacing-sm);
  margin-bottom: var(--spacing-sm);
  box-sizing: border-box;
}

.safety-copy {
  display: flex;
  flex-direction: column;
  gap: 3px;
  flex: 1;
}

.rule-box {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

@keyframes danmakuDrift {
  from {
    transform: translateX(0);
    opacity: 0;
  }
  8% {
    opacity: 1;
  }
  88% {
    opacity: 1;
  }
  to {
    transform: translateX(-760px);
    opacity: 0;
  }
}

@keyframes scanPulse {
  0% {
    opacity: 0.35;
    transform: scaleX(0.35);
  }
  50% {
    opacity: 1;
    transform: scaleX(1);
  }
  100% {
    opacity: 0.35;
    transform: scaleX(0.35);
  }
}

.app-shell {
  width: var(--app-width);
  height: var(--app-height-max);
  max-height: var(--app-height-max);
  padding: var(--spacing-sm) var(--spacing-md);
  background-color: var(--color-background);
  color: var(--color-text-primary);
  box-sizing: border-box;
}

.hud-frame {
  width: 100%;
  height: 364px;
  padding: var(--spacing-sm);
  border: var(--border-width-default) solid var(--border-color-default);
  border-radius: var(--radius-md);
  background-color: var(--color-surface);
  box-sizing: border-box;
  overflow: hidden;
}

.topbar {
  height: 44px;
  padding-bottom: var(--spacing-sm);
  border-bottom: var(--border-width-thin) solid var(--border-color-muted);
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: var(--spacing-sm);
}

.brand {
  width: 128px;
  height: 36px;
  padding: 4px 8px;
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-sm);
  background-color: var(--input-background-color);
  box-sizing: border-box;
}

.eyebrow {
  font-size: 10px;
  line-height: 11px;
  color: var(--color-text-secondary);
}

.title {
  font-size: 16px;
  line-height: 18px;
  font-weight: 700;
  color: var(--color-text-primary);
}

.top-status {
  flex: 1;
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  align-items: center;
  gap: var(--spacing-sm);
  min-width: 0;
}

.status-pill {
  width: 108px;
  min-width: 108px;
  height: 32px;
  padding: 3px 8px;
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-sm);
  background-color: var(--input-background-color);
  box-sizing: border-box;
}

.status-main {
  font-size: 11px;
  line-height: 13px;
  font-weight: 700;
  color: var(--color-text-primary);
  text-align: right;
  white-space: nowrap;
}

.status-sub {
  font-size: 10px;
  line-height: 11px;
  color: var(--color-text-secondary);
  text-align: right;
}

button,
.voice-pill,
.nav-chip,
.mini-btn,
.toggle-btn,
.chip {
  color: var(--color-text-secondary);
  background-color: var(--color-surface);
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-sm);
  box-sizing: border-box;
  font-size: 12px;
  line-height: 18px;
  min-height: 28px;
  padding: 0 8px;
  white-space: nowrap;
}

.voice-pill {
  width: 76px;
  height: 32px;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  gap: 5px;
  padding: 0 7px;
  font-size: 11px;
  line-height: 13px;
}

.voice-dot {
  width: 7px;
  height: 7px;
  border-radius: var(--radius-sm);
  border: var(--border-width-thin) solid var(--border-color-accent);
  background-color: var(--color-surface);
}

.voice-pill.is-active .voice-dot,
.nav-chip.is-active,
.mini-btn.is-active,
.toggle-btn.is-active,
.chip.is-active,
.strong-btn {
  color: var(--color-text-primary);
  border-color: var(--border-color-accent);
  background-color: var(--input-background-color);
}

.content {
  height: 292px;
  margin-top: var(--spacing-sm);
  display: grid;
  grid-template-columns: 70px 1fr;
  gap: var(--spacing-sm);
  overflow: hidden;
}

.module-rail {
  grid-column: 1;
  height: 292px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  padding-right: var(--spacing-sm);
  border-right: var(--border-width-thin) solid var(--border-color-muted);
  box-sizing: border-box;
}

.nav-slot {
  height: 38px;
}

.nav-chip {
  width: 61px;
  height: 38px;
  min-height: 38px;
  padding: 0;
  font-size: 12px;
  line-height: 34px;
}

.panel {
  grid-column: 2;
  width: 100%;
  height: 292px;
  overflow: hidden;
  box-sizing: border-box;
}

.live-panel {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.world-scene {
  position: relative;
  width: 100%;
  height: 244px;
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-md);
  background-color: var(--input-background-color);
  box-sizing: border-box;
  overflow: hidden;
}

.scene-anchor {
  left: var(--spacing-sm);
  top: var(--spacing-sm);
  width: 174px;
  padding: var(--spacing-sm);
  border: var(--border-width-thin) solid var(--border-color-muted);
  background-color: var(--color-surface);
}

.scene-name {
  margin-top: 4px;
  font-size: 17px;
  line-height: 20px;
  font-weight: 700;
}

.scene-signal {
  max-height: 42px;
  font-size: 11px;
  line-height: 14px;
  color: var(--color-text-secondary);
  overflow: hidden;
}

.section-kicker,
.memory-type,
.tone-tag,
.fav-tag,
.tone-text,
.detail-copy,
.memory-ref,
.persona-desc,
.persona-example,
.npc-line,
.safety-detail,
.recap-value {
  color: var(--color-text-secondary);
}

.meta-chip {
  padding: 1px 6px;
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-sm);
  font-size: 10px;
  line-height: 12px;
}

.world-reticle {
  width: 104px;
  height: 54px;
  border-top: var(--border-width-thin) solid var(--border-color-muted);
  border-bottom: var(--border-width-thin) solid var(--border-color-muted);
  opacity: 0.35;
}

.danmaku-fly {
  width: 246px;
  min-height: 52px;
  padding: var(--spacing-sm);
  border: var(--border-width-thin) solid var(--border-color-default);
  border-radius: var(--radius-md);
  background-color: var(--color-surface);
}

.danmaku-fly.is-selected {
  left: var(--spacing-sm);
  right: var(--spacing-sm);
  top: 12px;
  width: auto;
  max-height: 176px;
  border-width: var(--border-width-default);
  border-color: var(--border-color-accent);
  background-color: var(--color-surface);
}

.lane-0 {
  top: 22px;
}

.lane-1 {
  top: 96px;
}

.lane-2 {
  top: 170px;
}

.bubble-text {
  font-size: 13px;
  line-height: 17px;
  color: var(--color-text-primary);
}

.quiet-card {
  right: var(--spacing-sm);
  bottom: var(--spacing-sm);
  width: 220px;
  min-height: 62px;
  border: var(--border-width-default) solid var(--border-color-muted);
  background-color: var(--color-surface);
}

.control-strip {
  height: 36px;
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 6px;
  overflow: hidden;
}

.intensity-group {
  display: flex;
  flex-direction: row;
  gap: 4px;
}

.mini-btn {
  height: 30px;
  min-height: 30px;
  min-width: 34px;
  padding: 0 5px;
  font-size: 11px;
  line-height: 26px;
}

.split-panel {
  display: grid;
  grid-template-columns: 1fr 132px;
  gap: var(--spacing-sm);
}

.persona-list,
.memory-list,
.recap-list,
.safety-list {
  height: 292px;
  overflow: hidden;
}

.persona-card,
.memory-card,
.recap-row,
.safety-row,
.stat-box {
  border: var(--border-width-thin) solid var(--border-color-muted);
  border-radius: var(--radius-md);
  background-color: var(--color-surface);
  box-sizing: border-box;
}

.persona-card {
  padding: var(--spacing-sm);
  margin-bottom: var(--spacing-sm);
}

.persona-avatar,
.avatar {
  width: 28px;
  height: 28px;
  min-width: 28px;
  border: var(--border-width-thin) solid var(--border-color-accent);
  border-radius: var(--radius-sm);
  font-size: 13px;
  line-height: 28px;
  color: var(--color-text-primary);
}

.persona-title,
.memory-title,
.npc-name,
.recap-title,
.detail-title,
.side-title,
.safety-title {
  font-size: 15px;
  line-height: 18px;
  font-weight: 700;
  color: var(--color-text-primary);
}

.side-note,
.npc-card,
.favorites-card,
.rule-box,
.recap-main {
  border: var(--card-border-width) solid var(--card-border-color);
  border-radius: var(--radius-md);
  background-color: var(--color-surface);
  box-sizing: border-box;
}

.npc-card {
  padding: var(--spacing-md);
  gap: var(--spacing-sm);
}

.npc-level {
  font-size: 20px;
  line-height: 22px;
  font-weight: 700;
  color: var(--color-text-primary);
}

.stat-grid {
  grid-template-columns: 1fr 1fr 1.1fr;
  gap: var(--spacing-sm);
}

.roast-box {
  border-left: var(--border-width-strong) solid var(--border-color-accent);
  padding-left: var(--spacing-sm);
  font-size: 13px;
  line-height: 17px;
  color: var(--color-text-primary);
}

.memory-panel,
.safety-panel {
  display: grid;
  grid-template-columns: 1fr 142px;
  grid-template-rows: 34px 1fr;
  gap: var(--spacing-sm);
}

.memory-head,
.safety-head {
  grid-column: 1 / 3;
}

.memory-panel .memory-list,
.safety-panel .safety-list,
.memory-panel .favorites-card,
.safety-panel .rule-box {
  height: 250px;
}

.memory-card,
.recap-row,
.safety-row {
  padding: var(--spacing-sm);
  margin-bottom: var(--spacing-sm);
}

.favorites-card,
.rule-box {
  padding: var(--spacing-sm);
  overflow: hidden;
}

.recap-panel {
  display: grid;
  grid-template-columns: 134px 1fr;
  gap: var(--spacing-sm);
}

.recap-main {
  padding: var(--spacing-md) var(--spacing-sm);
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: var(--spacing-md);
}

.emotion-chart {
  width: 116px;
  height: 96px;
  gap: 6px;
}

.emotion-bar {
  width: 26px;
  border: var(--border-width-thin) solid var(--border-color-accent);
  border-radius: var(--radius-sm);
  background-color: var(--input-background-color);
}

.bar-low {
  height: 30px;
}

.bar-mid {
  height: 52px;
}

.bar-high {
  height: 76px;
}

.safety-row {
  align-items: center;
}

@keyframes danmakuDrift {
  from {
    transform: translateX(0);
    opacity: 0;
  }
  8% {
    opacity: 1;
  }
  88% {
    opacity: 1;
  }
  to {
    transform: translateX(-620px);
    opacity: 0;
  }
}
</style>
