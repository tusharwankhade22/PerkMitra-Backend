
-- =====================================================
-- PerkMitra
-- Migration V7: Audit Logs, Consent Events and Social Links
-- =====================================================

-- AUDIT LOGS
CREATE TABLE app.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID,
    actor_user_id UUID,
    actor_membership_id UUID,

    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id UUID,

    old_values JSONB,
    new_values JSONB,

    ip_address INET,
    user_agent TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_audit_logs_business
        FOREIGN KEY (business_id)
        REFERENCES app.businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_audit_logs_actor_user
        FOREIGN KEY (actor_user_id)
        REFERENCES app.users(id)
        ON DELETE RESTRICT,

   CONSTRAINT fk_audit_logs_actor_membership
       FOREIGN KEY (business_id, actor_membership_id, actor_user_id)
       REFERENCES app.business_members(business_id, id, user_id)
       ON DELETE RESTRICT,

    CONSTRAINT chk_audit_logs_actor_membership
       CHECK (
           (actor_membership_id IS NULL OR business_id IS NOT NULL)
           AND
           (actor_membership_id IS NULL OR actor_user_id IS NOT NULL)
       )
);

CREATE INDEX idx_audit_logs_business_created
    ON app.audit_logs (business_id, created_at DESC);

CREATE INDEX idx_audit_logs_actor
    ON app.audit_logs (actor_user_id, created_at DESC);

CREATE INDEX idx_audit_logs_entity
    ON app.audit_logs (entity_type, entity_id);


-- CUSTOMER CONSENT EVENTS
CREATE TABLE app.consent_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL,
    customer_id UUID NOT NULL,

    consent_type VARCHAR(50) NOT NULL,
    is_granted BOOLEAN NOT NULL,

    policy_version VARCHAR(50),
    consent_source VARCHAR(50),

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_consent_events_customer
        FOREIGN KEY (customer_id, business_id)
        REFERENCES app.customers(id, business_id)
        ON DELETE RESTRICT
);

CREATE INDEX idx_consent_events_business_customer
    ON app.consent_events (business_id, customer_id, created_at DESC);


-- BUSINESS SOCIAL LINKS
CREATE TABLE app.social_links (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL,

    platform VARCHAR(30) NOT NULL,
    url VARCHAR(1000) NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_social_links_business
        FOREIGN KEY (business_id)
        REFERENCES app.businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT uk_social_links_business_platform
        UNIQUE (business_id, platform),

    CONSTRAINT chk_social_links_platform
        CHECK (
            platform IN (
                'GOOGLE_REVIEWS',
                'INSTAGRAM',
                'WHATSAPP',
                'FACEBOOK',
                'WEBSITE'
            )
        )
);

CREATE INDEX idx_social_links_business
    ON app.social_links (business_id);


-- TABLE DOCUMENTATION
COMMENT ON TABLE app.audit_logs IS
'Records important platform and business activities for accountability.';

COMMENT ON TABLE app.consent_events IS
'Maintains an append-only history of customer consent changes.';

COMMENT ON TABLE app.social_links IS
'Stores business social media, review and website links.';
