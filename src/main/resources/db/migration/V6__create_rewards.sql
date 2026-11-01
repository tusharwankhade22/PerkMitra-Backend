
-- =====================================================
-- PerkMitra
-- Migration V6: Create Rewards
-- =====================================================

CREATE TABLE app.rewards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL,
    loyalty_card_id UUID NOT NULL,

    reward_description VARCHAR(500) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'EARNED',

    code_hash VARCHAR(255),

    earned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMPTZ,
    redeemed_at TIMESTAMPTZ,

    redeemed_by_user_id UUID,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_rewards_loyalty_card
        FOREIGN KEY (loyalty_card_id, business_id)
        REFERENCES app.loyalty_cards(id, business_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_rewards_redeemed_by_membership
        FOREIGN KEY (business_id, redeemed_by_user_id)
        REFERENCES app.business_members(business_id, user_id)
        ON DELETE RESTRICT,

    CONSTRAINT uk_rewards_id_business
        UNIQUE (id, business_id),

    CONSTRAINT chk_rewards_status
        CHECK (
            status IN ('EARNED', 'REDEEMED', 'EXPIRED', 'CANCELLED')
        ),

    CONSTRAINT chk_rewards_expiry
        CHECK (expires_at IS NULL OR expires_at > earned_at),

    CONSTRAINT chk_rewards_redemption
        CHECK (
            (status = 'REDEEMED'
                AND redeemed_at IS NOT NULL
                AND redeemed_by_user_id IS NOT NULL)
            OR
            (status <> 'REDEEMED'
                AND redeemed_at IS NULL
                AND redeemed_by_user_id IS NULL)
        )
);

-- Lookup rewards by business and status
CREATE INDEX idx_rewards_business_status
    ON app.rewards (business_id, status);

-- Lookup rewards for a loyalty card
CREATE INDEX idx_rewards_business_card
    ON app.rewards (business_id, loyalty_card_id);

-- Find rewards that are due to expire
CREATE INDEX idx_rewards_expiry
    ON app.rewards (expires_at)
    WHERE status = 'EARNED';

-- Prevent duplicate reward codes when a code is provided
CREATE UNIQUE INDEX uk_rewards_code_hash
    ON app.rewards (code_hash)
    WHERE code_hash IS NOT NULL;

COMMENT ON TABLE app.rewards IS
'Stores earned rewards and their redemption history for PerkMitra customers.';
