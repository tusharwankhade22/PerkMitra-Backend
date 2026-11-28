package com.perkmitra.repository;

import com.perkmitra.entity.AuditLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface AuditLogRepository extends JpaRepository<AuditLog, UUID> {

    List<AuditLog> findAllByBusiness_Id(UUID businessId);

    List<AuditLog> findAllByBusiness_IdAndActorUser_Id(UUID businessId, UUID actorUserId);

    List<AuditLog> findAllByBusiness_IdAndEntityTypeAndEntityId(UUID businessId, String entityType, UUID entityId);

    Optional<AuditLog> findByIdAndBusiness_Id(UUID auditLogId, UUID businessId);
}
