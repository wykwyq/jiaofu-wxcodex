import test from 'node:test';
import assert from 'node:assert/strict';
import {
  buildNatiemanjuRoutingInstructions,
  NATIEMANJU_SKILL_PATH,
  resolveNatiemanjuRoute,
} from '../../src/core/natiemanju_router.js';

test('natiemanju router force-matches screenplay production requests', () => {
  const route = resolveNatiemanjuRoute('根据这段内容生成制作剧本，然后开始制作第一集视频');

  assert.equal(route.matched, true);
  assert.deepEqual(route.matchedBy, ['视频制作流程', '剧本改编流程']);

  const instructions = buildNatiemanjuRoutingInstructions('根据这段内容生成制作剧本，然后开始制作第一集视频');
  assert.match(instructions, /强制技能路由：natiemanju/);
  assert.match(instructions, new RegExp(NATIEMANJU_SKILL_PATH.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')));
});

test('natiemanju router does not catch ordinary unrelated chat', () => {
  assert.deepEqual(resolveNatiemanjuRoute('帮我总结这封邮件'), {
    matched: false,
    matchedBy: [],
  });
  assert.equal(buildNatiemanjuRoutingInstructions('帮我总结这封邮件'), '');
});
