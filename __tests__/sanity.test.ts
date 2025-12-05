import { describe, it, expect } from 'vitest';

describe('Sanity check', () => {
  it('should pass basic test', () => {
    expect(true).toBe(true);
  });

  it('should perform basic arithmetic', () => {
    expect(1 + 1).toBe(2);
  });
});


