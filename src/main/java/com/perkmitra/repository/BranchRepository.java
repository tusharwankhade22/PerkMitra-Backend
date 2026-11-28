package com.perkmitra.repository;

import com.perkmitra.entity.Branch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface BranchRepository extends JpaRepository<Branch, UUID> {

    List<Branch> findAllByBusiness_Id(UUID businessId);

    Optional<Branch> findByIdAndBusiness_Id(UUID branchId, UUID businessId);

    boolean existsByIdAndBusiness_Id(UUID branchId, UUID businessId);
}
