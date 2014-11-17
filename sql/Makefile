
# Time-stamp: <2013-11-01 16:47:47 daniel>

# Makefile to upload into MySQL all stored procedures

# What should we build?
TARGETS := throw_error                \
           find_customer_from_fbid    \
           find_customer_from_plid    \
           update_account             \
           toggle_subscription        \
           customer_subscription_list \
           change_page                \
           initialize_subscription    \
           service_by_hour            \
           list_of_subscribers        \
           renew_subscription         \
           cancel_subscription        \
           kill_customer              \
           find_token


# Add in additional macros
include ../include.mk

# Build everything
all:	$(OBJECTS)
	@echo All scripts uploaded
