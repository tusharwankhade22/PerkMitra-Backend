package com.perkmitra.repository;

import com.perkmitra.entity.SocialLink;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface SocialLinkRepository extends JpaRepository<SocialLink, UUID> {

    List<SocialLink> findAllByBusiness_Id(UUID businessId);

    Optional<SocialLink> findByIdAndBusiness_Id(UUID socialLinkId, UUID businessId);

    boolean existsByBusiness_IdAndPlatform(UUID businessId, String platform);
}
