package com.perkmitra.repository;

import com.perkmitra.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, UUID> {

    List<Customer> findAllByBusiness_Id(UUID businessId);

    Optional<Customer> findByIdAndBusiness_Id(UUID customerId, UUID businessId);

    Optional<Customer> findByBusiness_IdAndPhone(UUID businessId, String phone);

    boolean existsByBusiness_IdAndPhone(UUID businessId, String phone);
}
