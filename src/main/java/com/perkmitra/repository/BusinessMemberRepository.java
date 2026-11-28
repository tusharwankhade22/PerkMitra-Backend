package com.perkmitra.repository;

import com.perkmitra.entity.BusinessMember;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface BusinessMemberRepository extends JpaRepository<BusinessMember, UUID> {

    List<BusinessMember> findAllByBusiness_Id(UUID businessId);

    Optional<BusinessMember> findByBusiness_IdAndUser_Id(UUID businessId, UUID userId);

    boolean existsByBusiness_IdAndUser_Id(UUID businessId, UUID userId);
}
